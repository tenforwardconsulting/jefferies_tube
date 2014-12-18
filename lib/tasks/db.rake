namespace :db do
  desc 'Capture a database backup to tmp/latest.dump'
  task :backup do
    sh "pg_dump \
        --verbose -Fc \
        #{hostname} #{username} -d #{db_config("database")} \
        -f #{Rails.root.join('tmp', 'latest.dump')}"
  end

  task :load do
    sh "pg_restore \
        --verbose --clean --no-acl --no-owner \
        #{hostname} #{username} -d #{db_config("database")} \
        #{Rails.root.join('tmp', 'latest.dump')}"
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
end