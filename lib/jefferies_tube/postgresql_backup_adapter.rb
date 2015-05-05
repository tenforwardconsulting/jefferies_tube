class PostgresqlBackupAdapter
  def create_backup(file)
    echo_run "#{password_option} pg_dump --verbose -Fc \
    #{host_option} #{username_option} -d #{database} \
    --file #{file}"
  end

  def restore_most_recent(file)
    echo_run "#{password_option} pg_restore --verbose --clean --no-acl --no-owner \
    #{host_option} #{username_option} -d #{database} \
    #{file}"
  end

  private

  def echo_run(cmd)
    puts ">> #{cmd}"
    `#{cmd}`
  end

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
