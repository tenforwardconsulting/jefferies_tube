if !defined?(Capistrano::VERSION)
  raise "Capistrano is not present."
elsif !Capistrano::VERSION.start_with?("3")
  raise "Capistrano support is limited to version 3"
end

require 'jefferies_tube/capistrano/assets'
require 'jefferies_tube/capistrano/db'
require 'jefferies_tube/capistrano/deploy'
require 'jefferies_tube/capistrano/maintenance'
require 'jefferies_tube/capistrano/rails'
require 'jefferies_tube/capistrano/ssh'
