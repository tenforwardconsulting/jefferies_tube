class DatabaseBackup
  BACKUP_DIR = 'db/backups'
  MAX_NUM_OF_BACKUPS = 10

  def initialize(database_backup_adapter)
    @database_backup_adapter = database_backup_adapter
  end

  def create
    @latest_backup_file = create_backup
    remove_symlink_to_old_backup
    create_symlink_to_new_backup
    delete_oldest_backup
    compress_old_backups
    @latest_backup_file
  end

  def restore_most_recent
    @database_backup_adapter.restore_most_recent symlink_file
  end

  def symlink_file
    File.join backup_path, 'latest.dump'
  end

  def backups
    Dir.glob(File.join(backup_path, '*'))
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
    File.join(root_dir, BACKUP_DIR).tap &FileUtils.method(:mkdir_p)
  end

  def old_backups
    backups.lazy.sort.reject { |r|
      r == @latest_backup_file || r == symlink_file
    }
  end

  def sh(cmd)
    `#{cmd}`
  end
end
