namespace :rails do
  desc "Open the rails console on each of the remote servers"
  task :console do
    on roles(:app), primary: true do |host, user|
      rails_env = fetch(:rails_env)
      run_interactively "RAILS_ENV=#{rails_env} bundle exec rails console"
    end
  end

  desc "Open the rails dbconsole on each of the remote servers"
  task :dbconsole do
    on roles(:db), primary: true do |host|
      rails_env = fetch(:rails_env)
      run_interactively "RAILS_ENV=#{rails_env} bundle exec rails dbconsole"
    end
  end

  desc "Open the rails log"
  task :log do
    on roles(:app), primary: true do |host, user|
      rails_env = ENV['LOG'] || fetch(:rails_env)
      run_interactively "tail -f log/#{rails_env}.log"
    end
  end

  def run_interactively(command)
    port = host.port || 22
    puts "ssh #{host.user}@#{host} -p #{port} -t 'cd #{deploy_to}/current; #{command}'"
    exec "ssh #{host.user}@#{host} -p #{port} -t 'cd #{deploy_to}/current; #{command}'"
  end
end

desc "Open an ssh session"
task :ssh do
  on roles(:app), primary: true do |host|
    run_interactively '/bin/bash'
  end
end



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

  desc "restore the database from a local file FILE=./local/file_path"
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

namespace :deploy do
  task :ensure_tag do
    tagname = `git describe --exact-match HEAD`.chomp
    if $? == 0
      puts "Code is tagged as `#{tagname}`, proceeding with deployment"
    else
      abort "You need to tag the source before you can deploy production"
    end
  end
  task :create_tag do
    now = Time.now
    tagname = "#{fetch(:stage)}-#{now.strftime('%Y-%m-%d-%H%M')}"
    me = `whoami`.chomp
    %x(git tag -a #{tagname} -m "Automated deploy tag by #{me}" && git push origin #{tagname})
  end
  task :backup_database do

    if fetch(:skip_deploy_backups)
      puts "Skipping database backup because :skip_deploy_backups is set"
    else
      invoke "db:backup"
    end
  end
end

before 'deploy:migrate', 'deploy:backup_database'

