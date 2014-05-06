module Podunk
  class App
    module Router
      class Route
        Match = Struct.new(:method, :params)

        @@routes = Hash.new {|h,k| h[k]=[]}

        def initialize(verb, path, method)
          @verb, @path, @method = verb, path, method

          @@routes[verb] << self
        end

        def self.for(verb, path)
          routes = @@routes[verb]

          return if routes.empty?

          routes.find {|route| route.match(path)}
        end

        # replaces all param names
        # e.g. :id in /hogera/:id
        # with a group to match values
        def path_re
          @re ||= Regexp.new @path.gsub(%r{(:[^/?#]+)}, '([^/?#]+)')
        end

        def match(path)
          if m = path.match(path_re)
            # e.g. grab the 'id' from '/hogera/:id'
            param_name  = @path[%r{/:([^/?#]+)}, 1]
            # e.g. grab the '123' val from '/hogera/123'
            param_value = m[1]

            params = {
              param_name => param_value
            }
            # require 'pry'; binding.pry

            Match.new @method, params
          end
        end

        def self.method_for_path(path)
          @@routes.find {|route|
            route.match(path).method
          }
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      # def routes
      #   self.class.routes
      # end

      def method_for_path
        Route.for(request.verb, request.path).method
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

        # def routes
        #   @@routes
        # end

      private
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
