# require jeffries_tube/capistrano in your Capfile and we'll figure out the version
if defined?(Capistrano::VERSION) && Capistrano::VERSION.start_with?("3")
  require 'jefferies_tube/capistrano/capistrano3'
else
  require 'jefferies_tube/capistrano/capistrano2'
end
