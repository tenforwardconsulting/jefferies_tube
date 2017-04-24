namespace :assets do
  desc "Fetch assets in public/system"
  task :fetch do
    on roles(:web), primary: true do |host|
      download! "#{deploy_to}/shared/public/system", "public", recursive: true
    end
  end
end
