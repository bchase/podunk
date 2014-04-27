require 'podunk/http/request/params'

module Podunk
  module HTTP
    class Request
      attr_reader :env, :params
      def initialize(env)
        @env = env
        @params = Params.new query_string: env['QUERY_STRING']
      end

      def method
        @env['REQUEST_METHOD']
      end
      alias :verb :method

      def path
        @env['REQUEST_PATH']
      end
    end
  end
end
