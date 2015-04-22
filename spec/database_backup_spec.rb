require 'spec_helper'
require 'tmpdir'
require 'pry'
require_relative '../lib/jefferies_tube/database_backup'

RSpec.describe DatabaseBackup do
  describe '::create' do
    let(:test_backup_adapter) {
      class TestBackupAdapter
        def create_backup(file)
          FileUtils.touch file
        end
      end
      TestBackupAdapter.new
    }
    let(:database_backup) { DatabaseBackup.new test_backup_adapter }
    let(:root_dir) { Dir.mktmpdir }

    before :each do
      database_backup.stub(:root_dir).and_return root_dir
    end

    after :each do
      FileUtils.remove_entry root_dir
    end

    it 'creates the backup directory' do
      backup_dir = File.join(root_dir, DatabaseBackup::BACKUP_DIR)
      expect {
        database_backup.create
      }.to change { Dir.exists? backup_dir }.from(false).to true
    end

    it 'creates a backup' do
      latest_backup_file = database_backup.create
      expect(File.exists? latest_backup_file).to eq true
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
      expect(File.exists? will_be_old_backup).to eq false
      expect(File.exists? "#{will_be_old_backup}.gz").to eq true
    end

    it 'deletes oldest backups' do
      DatabaseBackup.const_set 'MAX_NUM_OF_BACKUPS', 1
      will_be_deleted_backup = database_backup.create
      sleep 1 # To change the timestamp
      new_backup = database_backup.create
      expect(File.exists? will_be_deleted_backup).to eq false
      expect(File.exists? new_backup).to eq true
      expect(database_backup.backups.size).to eq 2
    end
  end

  describe '::restore_most_recent' do
    pending
  end
end
