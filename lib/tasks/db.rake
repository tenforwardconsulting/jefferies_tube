namespace :db do
  desc 'Capture a database backup to tmp/latest.dump'
  task :backup do
    puts "I only show up once"
    filename = "#{Time.now.strftime('%Y%m%d%H%M%S')}.dump"
    sh "pg_dump \
        --verbose -Fc \
        #{hostname} #{username} -d #{db_config("database")} \
        -f #{File.join(backup_path, filename)}"
    File.delete(File.join(backup_path, 'latest.dump')) if File.exists?(File.join(backup_path, 'latest.dump'))
    sh "ln -s #{File.join(backup_path, filename)} #{File.join(backup_path, 'latest.dump')}"
    files = Dir.glob(File.join(backup_path, '*')).sort.reject { |r| r == File.join(backup_path, filename) || r == File.join(backup_path, 'latest.dump')}
    if files.count > 5
      File.delete(files.first)
      files.delete(files.first)
    end
    files.each do |item|
      next if item =~ /.dump.gz/
      sh "gzip #{item}"
    end
  end

  task :load do
    sh "pg_restore \
        --verbose --clean --no-acl --no-owner \
        #{hostname} #{username} -d #{db_config("database")} \
        #{File.join(backup_path, 'latest.dump')}"
  end

  def username
    username = db_config('username')
    if (username)
      "-U #{username}"
    else
      ""
    end
  end

  def hostname
    hostname = db_config('host')
    if (hostname)
      "-h #{hostname}"
    else
      ""
    end
  end

  def db_config(key)
    Rails.configuration.database_configuration[Rails.env][key]
  end

  def backup_path
    path = Rails.root.join('db', 'backups')
    FileUtils.mkdir_p(path)

    path
  end
end