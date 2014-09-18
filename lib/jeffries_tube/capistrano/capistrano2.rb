namespace :rails do
  desc "Remote console"
  task :console, :roles => :app do
    run_interactively "RAILS_ENV=#{rails_env} bundle exec rails console"
  end

  desc "Remote dbconsole"
  task :dbconsole, :roles => :app do
    run_interactively "RAILS_ENV=#{rails_env} bundle exec rails dbconsole"
  end
end

def run_interactively(command, server=nil)
  server ||= find_servers_for_task(current_task).first
  puts %Q(ssh #{user}@#{server.host} -t 'bash -l -c "cd #{current_path} && #{command}"')
  exec %Q(ssh #{user}@#{server.host} -t 'bash -l -c "cd #{current_path} && #{command}"')
end