require 'tmpdir'
require_relative '../lib/jefferies_tube/database_backup'
require_relative '../lib/jefferies_tube/test_backup_adapter'

RSpec.describe DatabaseBackup do
  let(:database_backup_adapter) { TestBackupAdapter.new }
  let(:database_backup) { DatabaseBackup.new database_backup_adapter, max_num_of_backups: 2 }
  let(:root_dir) { Dir.mktmpdir }

  before :each do
    allow(database_backup).to receive(:root_dir).and_return root_dir
  end

  after :each do
    FileUtils.remove_entry root_dir
  end

  describe '#create' do
    it 'creates the backup directory' do
      backup_dir = File.join(root_dir, DatabaseBackup::BACKUP_DIR)
      expect {
        database_backup.create
      }.to change { Dir.exist? backup_dir }.from(false).to true
    end

    it 'creates a backup' do
      latest_backup_file = database_backup.create
      expect(File.exist? latest_backup_file).to eq true
    end

    it 'creates a symlink to the latest backup' do
      expect {
        database_backup.create
      }.to change { File.symlink? database_backup.symlink_file }.from(false).to true
    end

    it 'compresses old backups' do
      will_be_old_backup = database_backup.create
      sleep 1 # To change the timestamp
      database_backup.create
      expect(File.exist? will_be_old_backup).to eq false
      expect(File.exist? "#{will_be_old_backup}.gz").to eq true
    end

    it 'deletes oldest backups' do
      will_be_deleted_backup = database_backup.create
      sleep 1 # To change the timestamp
      second_backup = database_backup.create
      third_backup = database_backup.create
      expect(File.exist? will_be_deleted_backup).to eq false
      expect(File.exist? second_backup).to eq true
      expect(File.exist? third_backup).to eq true
      expect(database_backup.backups.size).to eq 3
    end
  end

  describe '#created_rotated' do
  end

  describe '#restore' do
    it 'restores using the database adapter' do
      expect(database_backup_adapter).to receive(:restore).with 'db/backups/foobar.dump'
      database_backup.restore 'db/backups/foobar.dump'
    end
  end

  describe '#restore_most_recent' do
    it 'restores latest.dump' do
      expect(database_backup_adapter).to receive(:restore).with File.join(root_dir, 'db/backups/latest.dump')
      database_backup.restore_most_recent
    end
  end
end
