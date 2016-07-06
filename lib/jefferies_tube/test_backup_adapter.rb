require_relative 'database_backup_adapter'

class TestBackupAdapter < DatabaseBackupAdapter
  def create_backup(file)
    FileUtils.touch file
  end

  def restore(file)
  end
end
