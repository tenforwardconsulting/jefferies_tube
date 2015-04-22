class PostgresqlBackupAdapter
  def create_backup(file)
    `pg_dump --verbose -Fc \
    #{username_option} #{database} \
    --file #{file}`
  end

  def restore_most_recent(file)
    `pg_restore --verbose --clean --no-acl --no-owner \
    #{host_option} #{username_option} -d #{database} \
    #{file}`
  end

  private

  def username_option
    username = db_config('username')
    if username
      "--username #{username}"
    else
      ""
    end
  end

  def host_option
    host = db_config('host')
    if host
      "--host #{host}"
    else
      ""
    end
  end

  def database
    db_config "database"
  end

  def db_config(key)
    Rails.configuration.database_configuration[Rails.env][key]
  end
end
