class DatabaseBackupAdapter
  def create_backup(file)
    raise NotImplementedError
  end

  def restore(file)
    raise NotImplementedError
  end
end
