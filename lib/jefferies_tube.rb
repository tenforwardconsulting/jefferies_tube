require 'jefferies_tube/version'
require 'jefferies_tube/engine' if defined?(Rails)

module JefferiesTube
  require 'jefferies_tube/railtie' if defined?(Rails)

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
    attr_accessor :environment
    attr_accessor :prompt_name

    def initialize
      if defined?(Rails)
        @environment = ::Rails.env.downcase || nil
        @prompt_name = ::Rails.application.class.parent_name || nil
      else
        @environment = "development"
        @prompt_name = "JefferiesTube"
      end
    end
  end
end
