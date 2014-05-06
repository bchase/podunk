module Podunk
  class App
    module Router
      class Route
        Match = Struct.new(:method, :params)

        @@routes = Hash.new {|h,k| h[k]=[]}

        attr_accessor :verb, :path, :method
        def initialize(verb, path, method)
          @verb, @path, @method = verb, path, method

          @@routes[verb] << self
        end

        def parts
          @parts ||= @path.split '/'
        end

        def degree
          parts.count
        end

        def self.for(verb, path)
          routes = @@routes[verb]

          return if routes.empty?

          matches = routes.map {|route| 
            route.match(path)
          }.reject(&:nil?)

          if !routes.empty?

            require 'pry'; binding.pry
            p_matches = matches.reject {|match| match.params.empty?}
            if !p_matches.empty?
              p_matches.first
            else
              matches.first
            end
          end

          routes.find {|route|
            route.match(path)
          }
        end

        # replaces all param names
        # e.g. :id in /hogera/:id
        # with a group to match values
        def path_re
          @re ||= Regexp.new @path.gsub(%r{(:[^/?#]+)}, '([^/?#]+)')
        end

        def match(path)
          # if m = path.match(path_re)
          #   # e.g. grab the 'id' from '/hogera/:id'
          #   param_name  = @path[%r{/:([^/?#]+)}, 1]
          #   # e.g. grab the '123' val from '/hogera/123'
          #   param_value = m[1]
          #
          #   params = param_name.nil? ? {} : {
          #     param_name => param_value
          #   }
          #
          #   Match.new @method, params
          # end

          params    = {}
          req_parts = path.split('/')
          if parts.with_index.all? do |part, idx|
              if m = part.match(%r{:(.+)})
                name, value = m[1], req_parts[idx]
                params[name] = value
              else
                req_parts[idx]
              end
            end
            Match.new @method, params
          end
        end

        def self.method_for_path(path)
          @@routes.find {|route|
            route.match(path).method
          }
        end
      end
    end
  end
end
