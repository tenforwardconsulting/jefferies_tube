require_relative '../jefferies_tube/database_backup'
require_relative '../jefferies_tube/postgresql_backup_adapter'

namespace :db do
  desc 'restore a backup. Defaults to "db/backups/latest.dump". options: FILE=path/to/backup.dump'
  task :restore do
    # Only supports Postgresql for now
    file = ENV['FILE'] || "db/backups/latest.dump"
    DatabaseBackup.new(PostgresqlBackupAdapter.new).restore(file)
  end

  desc 'Capture a database backup'
  task :backup do
    # Only supports Postgresql for now
    DatabaseBackup.new(PostgresqlBackupAdapter.new).create
  end

  namespace :backup do
    task :daily do
      DatabaseBackup.new(PostgresqlBackupAdapter.new).create_rotated(:daily)
    end

    task :hourly do
      DatabaseBackup.new(PostgresqlBackupAdapter.new).create_rotated(:hourly)
    end
  end
end
