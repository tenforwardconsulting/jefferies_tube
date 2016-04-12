require 'rack'

module JefferiesTube
  module Rack
    class Maintenance
      attr_reader :app, :options

      def initialize(app, options={})
        @app     = app
        @options = options
      end

      def call(env)
        #data = File.read(file)
        data = "Sorry, this site is down for maintenance"
        [ 503, { "Content-Type" => "text/plain", "Content-Length" => data.bytesize.to_s }, [data] ]
      end
    end
  end
end
