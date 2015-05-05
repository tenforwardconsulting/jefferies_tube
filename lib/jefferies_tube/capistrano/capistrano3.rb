namespace :rails do
  desc "Open the rails console on each of the remote servers"
  task :console do
    on roles(:app), primary: true do |host, user|
      rails_env = fetch(:stage)
      run_interactively "RAILS_ENV=#{rails_env} bundle exec rails console"
    end
  end

  desc "Open the rails dbconsole on each of the remote servers"
  task :dbconsole do
    on roles(:db), primary: true do |host|
      rails_env = fetch(:stage)
      run_interactively "RAILS_ENV=#{rails_env} bundle exec rails dbconsole"
    end
  end

  desc "Open the rails log"
  task :log do
    on roles(:app), primary: true do |host, user|
      rails_env = ENV['LOG'] || fetch(:stage)
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
        execute :rake, "db:backup", "RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end

  desc "Fetch the latest database backup"
  task :fetch do
    on roles(:db), primary: true do |host|
      download! "#{deploy_to}/shared/db/backups/latest.dump"
    end
  end
end

before 'deploy:migrate', 'db:backup'

