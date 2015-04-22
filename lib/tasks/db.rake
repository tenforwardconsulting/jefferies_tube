require_relative '../jefferies_tube/database_backup'
require_relative '../jefferies_tube/postgresql_backup_adapter'

namespace :db do
  desc 'Load most recent database backup'
  task :load do
    # Only supports Postgresql for now
    DatabaseBackup.new(PostgresqlBackupAdapter.new).restore_most_recent
  end

  desc 'Capture a database backup'
  task :backup do
    # Only supports Postgresql for now
    DatabaseBackup.new(PostgresqlBackupAdapter.new).create
  end
end
