module JefferiesTube::Coverage
  def self.default_converage
    {
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
  end

  def self.required_coverage=(hash)
    @required_coverage = hash
  end

  def self.required_coverage
    self.default_converage.merge(@required_coverage || {})
  end

  def self.configure(config)
    config.add_filter '/test/'
    config.add_filter '/spec/'
    config.add_filter '/config/'
    config.formatter SimpleCov::Formatter::HTMLFormatter
    config.add_group 'Controllers' do |src_file|
      src_file.filename.include?('app/controllers') && !src_file.filename.include?('api')
    end
    config.add_group 'API Controllers' do |src_file|
      src_file.filename.include?('app/controllers') && src_file.filename.include?('api')
    end
    config.add_group 'Models', 'app/models'
    config.add_group 'Services', 'app/services'
    config.add_group 'Helpers', 'app/helpers'
    config.add_group 'Policies', 'app/policies'
    config.add_group 'Jobs', 'app/jobs'
    config.add_group 'Mailers', 'app/mailers'
    config.add_group 'Libraries', 'lib'
    config.add_group 'Plugins', 'vendor/plugins'
  end

  def self.print_report(result)
    output = "=====================Test Coverage=====================\n"
    output << "Group            Files       Current / Required (Ideal)\n"
    overall_failed = false
    result.groups.each do |name, group|
      next if group.size.zero?
      failed = group.covered_percent.round(2) < required_coverage[name]
      warning = !failed && group.covered_percent.round(2) < default_converage[name]
      overall_failed = true if failed
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
      output << "#{color}#{name.ljust(16)} #{files} #{current} / #{required} (#{default_converage[name]}%)\e[0m\n"
    end
    output += "\n"
    puts output
    overall_failed
  end
end
