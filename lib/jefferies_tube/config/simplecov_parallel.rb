require 'simplecov'

test_env = ENV['TEST_ENV_NUMBER'].to_s.empty? ? '1' : ENV['TEST_ENV_NUMBER']
SimpleCov.command_name "rspec_#{test_env}"
SimpleCov.coverage_dir "coverage/worker_#{test_env}"
SimpleCov.start do
  JefferiesTube::Coverage.configure(self)
end
