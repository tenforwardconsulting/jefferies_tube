require 'jeffries_tube/version'
require 'jeffries_tube/engine'

module JeffriesTube
  require 'jeffries_tube/railtie' if defined?(Rails)
end
