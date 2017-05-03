namespace :assets do
  desc "Fetch assets in public/system"
  task :fetch do
    on roles(:web), primary: true do |host|
      download! "#{deploy_to}/shared/public/system", "public", recursive: true
    end
  end

  namespace :s3 do
    desc "Fetch s3 assets from AWS_BUCKET to public/system"
    task :fetch do
      puts "`aws` command not found. Please install the aws cli tools via `sudo pip install awscli`" and return unless File.executable?(`which aws`.strip)

      appyml_text = nil
      on roles(:web), primary: true do |host|
        appyml_text = capture :cat, "#{deploy_to}/shared/config/application.yml"
      end

      appyml = YAML.load appyml_text
      command = "AWS_ACCESS_KEY_ID=#{appyml['AWS_ACCESS_KEY_ID']} AWS_SECRET_ACCESS_KEY=#{appyml["AWS_SECRET_ACCESS_KEY"]} aws s3 sync s3://#{appyml['AWS_BUCKET']} public/system"
      puts "Running: #{command}"

      STDOUT.sync = true
      require 'open3'
      Open3.popen2e(command) do |i, stdout_and_err, thread|
        while line = stdout_and_err.gets do
          puts line
        end
      end

      puts "Done!"
    end
  end
end
