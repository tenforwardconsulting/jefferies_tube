task :upload_assets_to_s3 do
  on roles(fetch(:assets_roles)) do
    within release_path do
      with rails_env: fetch(:rails_env), rails_groups: fetch(:rails_assets_groups) do
        execute :rake, "assets:precompile"
      end

      appyml_text = capture :cat, "#{deploy_to}/shared/config/application.yml"
      appyml = YAML.load appyml_text
      execute "AWS_ACCESS_KEY_ID=#{appyml['AWS_ACCESS_KEY_ID']}", "AWS_SECRET_ACCESS_KEY=#{appyml["AWS_SECRET_ACCESS_KEY"]}", 'aws', 's3', 'sync', 'public/assets/', 's3://mobile-doorman-dev/assets'
    end
  end
end
