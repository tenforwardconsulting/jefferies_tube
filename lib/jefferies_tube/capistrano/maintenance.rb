namespace :maintenance do
  desc "Enable maintenance: set MESSAGE='We should be back in approximately 2 hours'"
  task :enable do
    on roles(:web) do |host, user|
      within current_path do
        message = ENV["MESSAGE"] || "We should return shortly."
        upload! StringIO.new(message), "#{current_path}/tmp/maintenance.txt"
        invoke 'deploy:restart'
      end
    end
  end

  desc "Disable maintenance mode"
  task :disable do
    on roles(:web) do |host, user|
      within current_path do
        execute :rm, "#{current_path}/tmp/maintenance.txt"
        invoke 'deploy:restart'
      end
    end
  end
end
