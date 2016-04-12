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
        end
      end
    end

    initializer "jefferies_tube.add_maintenance_middleware" do |config|
      if File.exists? "tmp/maintenance.txt"
        require 'jefferies_tube/rack/maintenance'
        config.middleware.use 'JefferiesTube::Rack::Maintenance'
      end
    end

    private
    def initialize_404_catchall

    end

    def install_maintenance_middleware

    end
  end
end
