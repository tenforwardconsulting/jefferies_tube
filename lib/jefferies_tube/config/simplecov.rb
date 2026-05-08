require 'simplecov'
SimpleCov.start do
  JefferiesTube::Coverage.configure(self)
end
SimpleCov.at_exit do
  SimpleCov.result.format!
  overall_failed = JefferiesTube::Coverage.print_report(SimpleCov.result)
  if overall_failed
    exit(SimpleCov::ExitCodes::MINIMUM_COVERAGE)
  end
end
