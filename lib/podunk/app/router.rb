require 'podunk/app/router/route'

module Podunk
  class App
    module Router
      def self.included(base)
        base.extend ClassMethods
      end

      def method_for_path
        route = Route.for(request.verb, request.path)
        request.params.merge! route.params
        route.method
      end

      def body_method_for_route
        method_for_path
      end

      def render_body_for_route
        body = self.send body_method_for_route
      end

      module ClassMethods
        def route(&block)
          yield
        end

      private
        def root(opts={})
          method = opts[:to]
          Route.root = method
        end

        def get(opts)
          register_route('GET', opts)
        end

        def register_route(verb, opts)
          check_verb!(verb) and check_route!(opts)

          path   = opts.keys.first
          method = opts.values.first

          Route.new verb, path, method
        end

        def check_verb!(verb)
          fail ArgumentError.new('not a valid HTTP verb') unless %w[GET POST PUT PATCH DELETE HEAD].include? verb
        end

        def check_route!(opts)
          fail ArgumentError.new('not a single element Hash') unless opts.is_a?(Hash) && opts.count == 1
        end
      end
    end
  end
end
