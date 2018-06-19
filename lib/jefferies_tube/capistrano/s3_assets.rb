task :upload_assets_to_s3 do
  on roles(fetch(:assets_roles)) do
    within release_path do
      appyml_text = capture :cat, "#{deploy_to}/shared/config/application.yml"
      appyml = YAML.load appyml_text
      execute "AWS_ACCESS_KEY_ID=#{appyml['AWS_ACCESS_KEY_ID']}", "AWS_SECRET_ACCESS_KEY=#{appyml["AWS_SECRET_ACCESS_KEY"]}", 'aws', 's3', 'sync', 'public/assets/', "#{fetch(:s3_destination)}/assets"
      if Dir.exists?('public/packs')
        execute "AWS_ACCESS_KEY_ID=#{appyml['AWS_ACCESS_KEY_ID']}", "AWS_SECRET_ACCESS_KEY=#{appyml["AWS_SECRET_ACCESS_KEY"]}", 'aws', 's3', 'sync', 'public/packs/', "#{fetch(:s3_destination)}/packs"
      end
    end
  end
end

# From https://github.com/capistrano/rails/issues/89
task :copy_assets_manifest do
  next unless roles(:web, :app).count > 1
  manifest_contents, manifest_name = nil, nil
  packs_manifest_contents, packs_manifest_name = nil, nil

  assets_path = release_path.join('public', fetch(:assets_prefix))
  packs_path = release_path.join('public/packs')

  on roles(fetch(:assets_roles)), primary: true do
    manifest_name = capture(:ls, assets_path.join('.sprockets-manifest*')).strip
    manifest_contents = download! assets_path.join(manifest_name)

    packs_manifest_name = capture(:ls, packs_path.join('manifest.json')).strip
    packs_manifest_contents = download! packs_path.join(packs_manifest_name)
  end
  on roles(:app) do
    execute :rm, '-f', assets_path.join('.sprockets-manifest*')
    upload! StringIO.new(manifest_contents), assets_path.join(manifest_name)

    execute :rm, '-f', packs_path.join('manifest.json')
    upload! StringIO.new(packs_manifest_contents), packs_path.join(packs_manifest_name)
  end
end

after "upload_assets_to_s3", :copy_assets_manifest
