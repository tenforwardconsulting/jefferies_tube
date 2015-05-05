require_relative '../jefferies_tube/database_backup'
require_relative '../jefferies_tube/postgresql_backup_adapter'

namespace :db do
  desc 'restore a backup [FILE=path/to/backup rake db:load]'
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

end
