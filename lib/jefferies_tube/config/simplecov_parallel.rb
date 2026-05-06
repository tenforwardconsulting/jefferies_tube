require 'simplecov'

test_env = ENV['TEST_ENV_NUMBER'].to_s.empty? ? '1' : ENV['TEST_ENV_NUMBER']
SimpleCov.command_name "rspec_#{test_env}"
SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'
  formatter SimpleCov::Formatter::HTMLFormatter
  add_group 'Controllers' do |src_file|
    src_file.filename.include?('app/controllers') && !src_file.filename.include?('api')
  end
  add_group 'API Controllers' do |src_file|
    src_file.filename.include?('app/controllers') && src_file.filename.include?('api')
  end
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Helpers', 'app/helpers'
  add_group 'Policies', 'app/policies'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'
  add_group 'Libraries', 'lib'
  add_group 'Plugins', 'vendor/plugins'
end
