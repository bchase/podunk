module Podunk
  class App
    module Router
      def self.included(base)
        base.extend ClassMethods
      end

      def routes
        self.class.routes
      end

      def body_method_for_route
        routes[request.method][request.path].intern
      end

      def render_body_for_route
        body = self.send body_method_for_route
        body.respond_to?(:each) ? body : [ body ]
      end

      module ClassMethods
        def route(&block)
          @@routes ||= {}
          yield
        end

        def routes
          @@routes
        end

        private
        def get(opts)
          register_route('GET', opts)
        end

        def register_route(verb, opts)
          check_verb!(verb) and check_route!(opts)

          path   = opts.keys.first
          method = opts.values.first

          @@routes[verb]     ||= {}
          @@routes[verb][path] = method
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
