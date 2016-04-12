namespace :deploy do
  task :ensure_tag do
    tagname = `git describe --exact-match HEAD`.chomp
    if $? == 0
      puts "Code is tagged as `#{tagname}`, proceeding with deployment"
    else
      abort "You need to tag the source before you can deploy production"
    end
  end

  task :create_tag do
    now = Time.now
    tagname = "#{fetch(:stage)}-#{now.strftime('%Y-%m-%d-%H%M')}"
    me = `whoami`.chomp
    %x(git tag -a #{tagname} -m "Automated deploy tag by #{me}" && git push origin #{tagname})
  end

  task :backup_database do
    if fetch(:skip_deploy_backups)
      puts "Skipping database backup because :skip_deploy_backups is set"
    else
      invoke "db:backup"
    end
  end
end

before 'deploy:migrate', 'deploy:backup_database'
