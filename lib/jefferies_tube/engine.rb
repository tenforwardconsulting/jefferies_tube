module JefferiesTube
  module Rails
    class Engine < ::Rails::Engine
      initializer 'jefferies_tube.engine', :group => :all do |app|
        app.config.assets.paths << root.join('assets', 'stylesheets')
      end
    end
  end
end
