namespace :db do
  desc "Capture a database snapshot"
  task :backup do
    on roles(:db), primary: true do |host|
      unless fetch(:linked_dirs).include?("db/backups")
        warn "'db/backups' is not in your capistrano linked_dirs; you should add it yo"
      end
      within release_path do
        execute :rake, "db:backup", "RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

  desc "Fetch the latest database backup"
  task :fetch do
    on roles(:db), primary: true do |host|
      FileUtils.mkdir_p 'db/backups'
      download! "#{deploy_to}/shared/db/backups/latest.dump", "db/backups/latest-#{fetch(:stage)}.dump"
    end
  end

  desc "Restore the database from a local file FILE=./local/file_path"
  task :restore do
    on roles(:app), primary: true do |host|
      within release_path do
        remote_path = "#{release_path}/db/backups/#{File.basename(ENV["FILE"])}"
        upload! ENV["FILE"], remote_path
        execute :rake, "db:restore", "RAILS_ENV=#{fetch(:rails_env)}", "FILE=#{remote_path}"
      end
    end
  end
end
