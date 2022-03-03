namespace :rails do
  desc "Open the rails console on each of the remote servers"
  task :console do
    console_roles = [roles(:worker), roles(:app)].find(&:any?)
    on console_roles, primary: true do |host, user|
      run_interactively "RAILS_ENV=#{rails_env} JEFFERIES_TUBE_IRB=1 bundle exec rails console"
    end
  end

  desc "Open the rails dbconsole on each of the remote servers"
  task :dbconsole do
    on roles(:db), primary: true do |host|
      run_interactively "RAILS_ENV=#{rails_env} bundle exec rails dbconsole"
    end
  end

  desc "Open the rails log"
  task :log do
    on roles(:app), primary: true do |host, user|
      filename = ENV['LOG'] || rails_env
      run_interactively %Q{tail -f log/#{filename}.log | grep --line-buffered --invert "Delayed::Backend::ActiveRecord::Job Load"}
    end
  end

  desc "Open all rails log using multitail"
  task :allthelogs do
    commands = []
    roles(:app).each do |host|
      filename = ENV['LOG'] || rails_env
      port = host.port || 22
      commands << "ssh #{host.user}@#{host} -p #{port} \"tail -f #{deploy_to}/current/log/#{filename}.log\" | grep --line-buffered --invert \"Delayed::Backend::ActiveRecord::Job Load\""
    end

    command = "multitail"
    commands.each do |c|
      command += " -L '#{c}'"
    end

    puts command
    exec command
  end

  desc "Run a rake task"
  task :rake, :task_to_run do |_, parameters|
    task_to_run = parameters[:task_to_run]
    abort "Must supply task to run on remote server.\nUsage example: cap dev rails:rake[flipper:synchronize_features]" if task_to_run.nil?
    roles = [roles(:worker), roles(:app)].find(&:any?)
    on roles, primary: true do
      run_interactively "RAILS_ENV=#{rails_env} bundle exec rake #{task_to_run}"
    end
  end

  def run_interactively(command)
    port = host.port || 22
    puts "ssh #{host.user}@#{host} -p #{port} -t 'cd #{deploy_to}/current; #{command}'"
    exec "ssh #{host.user}@#{host} -p #{port} -t 'cd #{deploy_to}/current; #{command}'"
  end

  def rails_env
    fetch(:rails_env)
  end
end
