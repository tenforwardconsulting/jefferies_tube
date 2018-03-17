task :upload_assets_to_s3 do
  on roles(fetch(:assets_roles)) do
    within release_path do
      appyml_text = capture :cat, "#{deploy_to}/shared/config/application.yml"
      appyml = YAML.load appyml_text
      execute "AWS_ACCESS_KEY_ID=#{appyml['AWS_ACCESS_KEY_ID']}", "AWS_SECRET_ACCESS_KEY=#{appyml["AWS_SECRET_ACCESS_KEY"]}", 'aws', 's3', 'sync', 'public/assets/', fetch(:s3_destination)
    end
  end
end

# From https://github.com/capistrano/rails/issues/89
task :copy_assets_manifest do
  next unless roles(:web, :app).count > 1
  manifest_contents, manifest_name = nil, nil
  assets_path = release_path.join('public', fetch(:assets_prefix))

  on roles(fetch(:assets_roles)), primary: true do
    manifest_name = capture(:ls, assets_path.join('.sprockets-manifest*')).strip
    manifest_contents = download! assets_path.join(manifest_name)
  end
  on roles(:app) do
    execute :rm, '-f', assets_path.join('.sprockets-manifest*')
    upload! StringIO.new(manifest_contents), assets_path.join(manifest_name)
  end
end

after "upload_assets_to_s3", :copy_assets_manifest
