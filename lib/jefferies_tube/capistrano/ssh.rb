desc "Open an ssh session"
task :ssh do
  on roles(:app), primary: true do |host|
    port = host.port || 22
    puts "ssh #{host.user}@#{host} -p #{port}"
    exec "ssh #{host.user}@#{host} -p #{port}"
  end
end
