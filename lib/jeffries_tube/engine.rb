module JeffriesTube
  module Rails
    class Engine < ::Rails::Engine
      initializer 'jeffries_tube.engine', :group => :all do |app|
        app.config.assets.paths << root.join('assets', 'stylesheets')
      end
    end
  end
end
