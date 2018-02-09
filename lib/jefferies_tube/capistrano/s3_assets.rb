task :upload_assets_to_s3 do
  on roles(fetch(:assets_roles)) do
    within release_path do
      appyml_text = capture :cat, "#{deploy_to}/shared/config/application.yml"
      appyml = YAML.load appyml_text
      execute "AWS_ACCESS_KEY_ID=#{appyml['AWS_ACCESS_KEY_ID']}", "AWS_SECRET_ACCESS_KEY=#{appyml["AWS_SECRET_ACCESS_KEY"]}", 'aws', 's3', 'sync', 'public/assets/', fetch(:s3_destination)
    end
  end
end
