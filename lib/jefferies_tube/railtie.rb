require 'jefferies_tube'
require 'jefferies_tube/console'
require 'jefferies_tube/coverage'
require 'jefferies_tube/invalid_request_handler'
require 'rails'

module JefferiesTube
  class Railtie < ::Rails::Railtie
    railtie_name :jefferies_tube

    console do
      ActiveRecord::Base.connection

      ARGV.push "-r", File.join(File.dirname(__FILE__),"custom_prompts.irbrc.rb")

      require 'pry'
      if defined? Pry
        Pry.prompt = Pry::Prompt.new(:jefferies_tube, 'Jefferies Tube custom prompt', JefferiesTube::Console.pry_prompts)
      end
    end

    config.after_initialize do |args|
      begin
        # if this route exists, it means the app already defined its own catchall route
        # if not, this will raise an exception and we will install our catchall instead
        ::Rails.application.routes.recognize_path("/jefferies_tube_404_test_route_test_supertest")
      rescue ActionController::RoutingError
        ::Rails.application.routes.append do
          match "*a" => "jefferies_tube/errors#render_404", via: [:get, :post, :put, :options]
          match "/" => "jefferies_tube/errors#render_404", via: :post
        end
      end
    end

    initializer "jefferies_tube.add_maintenance_middleware" do |config|
      if File.exist? "tmp/maintenance.txt"
        require 'jefferies_tube/rack/maintenance'
        config.middleware.use 'JefferiesTube::Rack::Maintenance'
      end
    end

    initializer "jefferies_tube.view_helpers" do
      ::Rails.application.reloader.to_prepare do
        ActionView::Base.send :include, JefferiesTube::ApplicationHelper
      end
    end

    initializer "fix spring + figaro" do |config|
      if defined?(Spring) && File.exist?("config/application.yml")
        require 'spring/watcher'
        Spring.watch "config/application.yml"
      end
    end

    initializer "jefferies_tube.ensure_up_to_date" do |config|
      if ::Rails.env.development?
        if JefferiesTube::VERSION != JefferiesTube.latest_rubygems_version
          puts "***** Warning JefferiesTube is not up to date!"
        end
      end
    end

    initializer "load my.development.rb if present" do |config|
      if ::Rails.env.development?
        override_file = ::Rails.root.join "config", "environments", "my.development.rb"
        if File.file? override_file
          load override_file
        end
      end
    end

    initializer "create default rubocop config if missing" do |config|
      default_rubocop = File.join(File.dirname(__FILE__), "config", "rubocop_default.yml")
      rubocop_path = ::Rails.root.join ".rubocop.yml"
      if !File.file?(rubocop_path)
        FileUtils::cp(default_rubocop, rubocop_path)
      end
    end

    initializer 'load simplecov for tests' do |config|
      existing_spec_helper = File.join(::Rails.root.join "spec", "spec_helper.rb" )
      if File.exist?(existing_spec_helper) && !(File.open(existing_spec_helper, &:readline) == "ENV['JT_RSPEC'] = 'true'\n")
        content = File.read(existing_spec_helper)
        File.open(existing_spec_helper, "w") do |line|
          line.puts "ENV['JT_RSPEC'] = 'true'"
          line.puts "# ENV['JT_RSPEC'] = 'true' is required for correctly running SimpleCov via the jefferies_tube default rake task"
          line.puts "\n"
          line.puts content
        end
      end

      if ::Rails.env.test? && ENV['TEST_ENV_NUMBER'] && ENV['JT_RSPEC'] == 'true'
        ::Rails.configuration.eager_load = true
        ENV['JT_RSPEC'] = nil
        require_relative 'config/simplecov_parallel'
      elsif ::Rails.env.test? && ENV['JT_RSPEC'] == 'true'
        ::Rails.configuration.eager_load = true
        ENV['JT_RSPEC'] = nil
        simplecov_config = 'config/simplecov.rb'
        require_relative simplecov_config
      end
    end

    initializer 'handle invalid mime types' do |config|
      config.middleware.insert_before Rack::Head, JefferiesTube::InvaildRequestHandler
    end

    # This filter must match the error types rescued in InvaildRequestHandler.
    # If you update the rescue logic there, update the cases here too.
    config.after_initialize do
      if defined?(NewRelic::Agent) && NewRelic::Agent.respond_to?(:ignore_error_filter)
        existing_filter = NewRelic::Agent::ErrorCollector.ignore_error_filter
        puts "[JefferiesTube] Configuring NewRelic ignore_error_filter for invalid request errors" unless ::Rails.env.test?

        NewRelic::Agent.ignore_error_filter do |error|
          keep = case error
          when ActionDispatch::Http::MimeNegotiation::InvalidType
            false
          when ArgumentError
            !(error.message =~ /invalid byte sequence in UTF-8/ ||
              error.message =~ /invalid %-encoding/)
          when ActionController::BadRequest
            !(error.message =~ /invalid %-encoding/ ||
              error.message =~ /Invalid encoding for parameter/)
          else
            true
          end

          keep && (existing_filter.nil? || existing_filter.call(error))
        end
      elsif defined?(NewRelic::Agent)
        puts "[JefferiesTube] NewRelic::Agent.ignore_error_filter is not available. " \
          "Invalid request errors may still be reported to NewRelic."
      end
    end
  end
end
