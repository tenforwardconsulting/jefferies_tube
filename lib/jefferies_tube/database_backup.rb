class DatabaseBackup
  BACKUP_DIR = 'db/backups'
  MAX_NUM_OF_BACKUPS = 10

  def initialize(database_backup_adapter)
    @database_backup_adapter = database_backup_adapter
  end

  def create
    FileUtils.mkdir_p backup_path
    @latest_backup_file = create_backup
    remove_symlink_to_old_backup
    create_symlink_to_new_backup
    delete_oldest_backup
    compress_old_backups
    @latest_backup_file
  end

  def create_rotated(frequency)
    @rotate_frequency = frequency
    create
    cleanup
  end

  def restore(path)
    @database_backup_adapter.restore path
  end

  def restore_most_recent
    @database_backup_adapter.restore symlink_file
  end

  def symlink_file
    File.join backup_path, 'latest.dump'
  end

  def backups
    Dir.glob(File.join(backup_path, '*'))
  end

  def cleanup
    # hourly - keep for 24 hours
    sh "find #{storage_path}/backup.hourly/ -mmin +1440 -exec rm -rv {} \\;"
    # daily - keep for 14 days
    sh "find #{storage_path}/backup.daily/ -mtime +14 -exec rm -rv {} \\;"
    # weekly - keep for 60 days
    sh "find #{storage_path}/backup.weekly/ -mtime +60 -exec rm -rv {} \\;"
    # monthly - keep for 300 days
    sh "find #{storage_path}/backup.monthly/ -mtime +300 -exec rm -rv {} \\;"
  end

  private

  # Procedural Methods
  def create_backup
    backup_filename = "#{Time.now.strftime('%Y%m%d%H%M%S')}.dump"
    latest_backup_file = File.join backup_path, backup_filename
    @database_backup_adapter.create_backup latest_backup_file
    latest_backup_file
  end

  def remove_symlink_to_old_backup
    File.delete(symlink_file) if File.exists?(symlink_file)
  end

  def create_symlink_to_new_backup
    sh "ln -sf #{@latest_backup_file} #{symlink_file}"
  end

  def delete_oldest_backup
    File.delete(old_backups.first) if old_backups.count >= MAX_NUM_OF_BACKUPS
  end

  def compress_old_backups
    old_backups.each do |backup_filename|
      next if backup_filename =~ /.dump.gz/
      sh "gzip #{backup_filename}"
    end
  end

  # Helper Methods
  def root_dir
    Rails.root
  end

  def backup_path
    if @rotate_frequency
      rotated_backup_path(@rotate_frequency)
    else
      storage_path
    end
  end

  def storage_path
    File.join(root_dir, BACKUP_DIR)
  end

  def rotated_backup_path(frequency = :daily)
    storage = File.join(root_dir, BACKUP_DIR)
    now = Time.now
    if now.day == 1
      storage = File.join(storage, 'backup.monthly')
    elsif now.wday == 0
      storage = File.join(storage, 'backup.weekly')
    elsif frequency == :daily || now.hour == 0
      storage = File.join(storage, 'backup.daily')
    elsif frequency == :hourly
      storage = File.join(storage, 'backup.hourly')
    end

    storage
  end

  def old_backups
    backups.sort.reject { |r|
      r == @latest_backup_file || r == symlink_file
    }
  end

  def sh(cmd)
    `#{cmd}`
  end
end
