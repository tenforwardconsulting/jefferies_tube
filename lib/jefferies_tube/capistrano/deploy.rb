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
    ignore = fetch(:bundler_audit_ignore, [])
    scanner.scan(ignore: ignore) do |result|
      vulnerable = true

      gem_name = result.gem.name

      begin
        latest_version = `gem search #{gem_name}`
          .split("\n")
          .detect { |g|
            g.split(' ')[0] == gem_name
          }
          .split(' ')[1]
          .gsub(/[()]/, "")
      rescue StandardError => e
        puts "Error reading 'gem search' output: #{e.message}"
      end

      case result
      when Bundler::Audit::Scanner::InsecureSource
        puts "Insecure Source URI found: #{result.source}"
      when Bundler::Audit::Scanner::UnpatchedGem
        if latest_version == result.gem.version.to_s
          vulnerable = false
          puts "#{result.gem} is not secure but there is no newer version!"
        else
          puts "#{result.gem} is not secure and there is a newer version available! (#{latest_version})"
        end
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
