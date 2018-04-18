require 'jefferies_tube'
require 'rails'

module JefferiesTube
  class Railtie < ::Rails::Railtie
    railtie_name :jefferies_tube

    console do
      ActiveRecord::Base.connection
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
      if File.exists? "tmp/maintenance.txt"
        require 'jefferies_tube/rack/maintenance'
        config.middleware.use 'JefferiesTube::Rack::Maintenance'
      end
    end

    initializer "jefferies_tube.view_helpers" do
      ActionView::Base.send :include, JefferiesTube::ApplicationHelper
    end


    initializer "fix spring + figaro" do |config|
      if defined?(Spring) && File.exists?("config/application.yml")
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
  end
end
