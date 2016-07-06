require_relative 'database_backup_adapter'

class PostgresqlBackupAdapter < DatabaseBackupAdapter
  def create_backup(file)
    `#{password_option} pg_dump --verbose -Fc \
    #{host_option} #{username_option} --file #{file} \
    #{database}
    `
  end

  def restore(file)
    `#{password_option} pg_restore --verbose --clean --no-acl --no-owner \
    #{host_option} #{username_option} -d #{database} \
    #{file}`
  end

  private

  def db_option(name)
    value = db_config(name)
    if (value)
      "--#{name}=#{value}"
    else
      ""
    end
  end

  def username_option
    db_option('username')
  end

  def password_option
    password = db_config('password')
    if password
      password_option = "PGPASSWORD=\"#{password}\""
    else
      password_option = ""
    end
  end

  def host_option
    db_option('host')
  end

  def database
    db_config "database"
  end

  def db_config(key)
    Rails.configuration.database_configuration[Rails.env][key]
  end
end
