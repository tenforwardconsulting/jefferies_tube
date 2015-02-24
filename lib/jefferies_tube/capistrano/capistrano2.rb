Capistrano::Configuration.instance(:must_exist).load do
  namespace :rails do
    desc "Remote console"
    task :console, :roles => :app do
      run_interactively "RAILS_ENV=#{rails_env} bundle exec rails console"
    end

    desc "Remote dbconsole"
    task :dbconsole, :roles => :app do
      run_interactively "RAILS_ENV=#{rails_env} bundle exec rails dbconsole"
    end

    desc "Open the rails log"
    task :log , :roles =>  :app do
      rails_env = ENV['LOG'] if ENV['LOG'].present?
      run_interactively "tail -f log/#{rails_env}.log"
    end
  end

  def run_interactively(command, server=nil)
    server ||= find_servers_for_task(current_task).first
    puts %Q(ssh #{user}@#{server.host} -t 'bash -l -c "cd #{current_path} && #{command}"')
    exec %Q(ssh #{user}@#{server.host} -t 'bash -l -c "cd #{current_path} && #{command}"')
  end
end
