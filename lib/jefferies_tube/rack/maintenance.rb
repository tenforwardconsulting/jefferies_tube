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
        message = File.read('./tmp/maintenance.txt')
        message = "Sorry, this site is down for maintenance." if message.empty?
        [ 503, { "Content-Type" => "text/plain", "Content-Length" => message.bytesize.to_s }, [message] ]
      end
    end
  end
end
