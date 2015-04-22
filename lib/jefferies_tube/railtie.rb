require 'jefferies_tube'
require 'rails'
module JefferiesTube
  class Railtie < ::Rails::Railtie
    railtie_name :jefferies_tube

    console do
      ActiveRecord::Base.connection
    end
  end
end