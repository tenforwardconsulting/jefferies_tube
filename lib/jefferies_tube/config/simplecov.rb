require 'simplecov'
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
SimpleCov.at_exit do
  SimpleCov.result.format!
  ideal_coverage = {
    'Controllers' => 10,
    'API Controllers' => 100,
    'Models' => 100,
    'Services' => 100,
    'Helpers' => 10,
    'Policies' => 100,
    'Jobs' => 100,
    'Mailers' => 0,
    'Libraries' => 0,
    'Plugins' => 0,
    'Ungrouped' => 10
  }
  required_coverage = JefferiesTube::Coverage.required_coverage
  overall_failed = false
  output = "=====================Test Coverage=====================\n"
  output << "Group            Files       Current / Required (Ideal)\n"
  SimpleCov.result.groups.each do |name, group|
    next if group.size.zero?
    failed = false
    warning = false
    if group.covered_percent.round(2) < ideal_coverage[name]
      warning = true
    end
    if group.covered_percent.round(2) < required_coverage[name]
      warning = false
      failed = true
      overall_failed = true
    end
    color = if failed
      "\e[31m"
    elsif warning
      "\e[33m"
    else
      "\e[32m"
    end
    files = "Files: #{group.size}".ljust(11)
    current = "#{group.covered_percent.round(2)}%".ljust(7)
    required = "#{required_coverage[name]}%".ljust(8)
    output << "#{color}#{name.ljust(16)} #{files} #{current} / #{required} (#{ideal_coverage[name]}%)\e[0m\n"
  end
  output += "\n"
  puts output
  if overall_failed
    exit(SimpleCov::ExitCodes::MINIMUM_COVERAGE)
  end
end
