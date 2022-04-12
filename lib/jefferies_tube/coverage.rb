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
end
