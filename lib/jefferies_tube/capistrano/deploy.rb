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

  task :scan_gems do
    require 'bundler/audit/scanner'
    require 'bundler/audit/database'

    Bundler::Audit::Database.update!
    scanner = Bundler::Audit::Scanner.new
    vulnerable = false

    scanner.scan do |result|
      vulnerable = true
      case result
      when Bundler::Audit::Results::InsecureSource
        puts "Insecure Source URI found: #{result.source}"
      when Bundler::Audit::Results::UnpatchedGem
        puts "#{result.gem} is not secure!"
      end
    end
    if vulnerable && ENV["I_KNOW_GEMS_ARE_INSECURE"] == nil
      abort """
      Your Gemfile.lock contains unpatched gems -- refusing to deploy
      Run `bundle-audit check --update` for full information
      You can set 'I_KNOW_GEMS_ARE_INSECURE' if you really want to do this anyway
      """
    end
  end
end

before 'deploy:migrate', 'deploy:backup_database'
before 'deploy', 'deploy:scan_gems'
