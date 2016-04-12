desc "Open an ssh session"
task :ssh do
  on roles(:app), primary: true do |host|
    run_interactively '/bin/bash'
  end
end
