if Gem.loaded_specs.key?('parallel_tests')
  Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
  Rake::Task[:jtspec].clear if Rake::Task.task_defined?(:jtspec)

  task :jtspec do
    Rake::Task["parallel:clear_coverage"].invoke
    Rake::Task["parallel:prepare"].invoke
    Rake::Task["parallel:spec"].invoke
    Rake::Task["parallel:collate_coverage"].invoke
  end

  task default: :jtspec
  task default: :rubocop

  namespace :parallel do
    desc "Clear stale coverage data before parallel test run"
    task :clear_coverage do
      FileUtils.rm_rf("coverage")
    end

    desc "Collate SimpleCov results from parallel test runs"
    task collate_coverage: :environment do
      require 'simplecov'
      SimpleCov.collate Dir["coverage/.resultset.json"] do
        formatter SimpleCov::Formatter::HTMLFormatter
        add_filter '/test/'
        add_filter '/config/'
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

      overall_failed = JefferiesTube::Coverage.print_report(SimpleCov.result)

      if overall_failed
        exit(SimpleCov::ExitCodes::MINIMUM_COVERAGE)
      end
    end
  end
end
