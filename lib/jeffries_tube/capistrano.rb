# require jeffries_tube/capistrano in your Capfile and we'll figure out the version
if Capistrano::VERSION.start_with? "3"
  require 'jeffries_tube/capistrano/capistrano3'
elsif Capistrano::VERSION.start_with? "2"
  require 'jeffries_tube/capistrano/capistrano2'
else
  puts "Unsupported Capistrano Version"
end
