namespace :rails do
  desc "Open the rails console on each of the remote servers"
  task :console do
    console_roles = [roles(:worker), roles(:app)].find(&:any?)
    on console_roles, primary: true do |host, user|
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
      run_interactively %Q{tail -f log/#{rails_env}.log | grep --line-buffered --invert "Delayed::Backend::ActiveRecord::Job Load"}
    end
  end

  def run_interactively(command)
    port = host.port || 22
    puts "ssh #{host.user}@#{host} -p #{port} -t 'cd #{deploy_to}/current; #{command}'"
    exec "ssh #{host.user}@#{host} -p #{port} -t 'cd #{deploy_to}/current; #{command}'"
  end
end
