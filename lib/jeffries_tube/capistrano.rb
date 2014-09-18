# require jeffries_tube/capistrano in your Capfile and we'll figure out the version
if defined?(Capistrano::VERSION) && Capistrano::VERSION.start_with?("3")
  require 'jeffries_tube/capistrano/capistrano3'
else
  require 'jeffries_tube/capistrano/capistrano2'
end
