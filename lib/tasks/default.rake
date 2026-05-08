task(:default).clear

if Gem.loaded_specs.key?('rspec-core')
  require 'rspec/core/rake_task'
  task :jtspec do
    Rake::Task["spec"].invoke
  end
  task default: :jtspec
elsif Gem.loaded_specs.key?('minitest')
  task :jtspec do
    Rake::Task["test"].invoke
    if Rake::Task.task_defined?("test:system")
      Rake::Task["test:system"].invoke
    end
  end
  task default: :jtspec
end

require 'rubocop/rake_task'

if Object.const_defined?("DEBUGGER__")
  DEBUGGER__.class_eval do
    def self.warn(msg)
    end
  end
end

RuboCop::RakeTask.new(:rubocop)
task default: :rubocop

if Gem.loaded_specs.key?('parallel_tests')
  Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
  Rake::Task[:jtspec].clear if Rake::Task.task_defined?(:jtspec)

  task :jtspec do
    Rake::Task["parallel:clear_coverage"].invoke
    Rake::Task["parallel:prepare"].invoke
    ENV['JT_RSPEC'] = 'true'
    Rake::Task["parallel:spec"].invoke
    ENV['JT_RSPEC'] = nil
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
      SimpleCov.collate Dir["coverage/worker_*/.resultset.json"] do
        JefferiesTube::Coverage.configure(self)
      end

      overall_failed = JefferiesTube::Coverage.print_report(SimpleCov.result)

      if overall_failed
        exit(SimpleCov::ExitCodes::MINIMUM_COVERAGE)
      end
    end
  end
end
