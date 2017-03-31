desc "Open an ssh session"
task :ssh do
  on roles(:app), primary: true do |host|
    port = host.port || 22
    cmd = %Q|ssh #{host.user}@#{host} -p #{port} -t "cd /u/apps/stimmi/current && exec bash -l"|
    puts cmd
    exec cmd
  end
end
