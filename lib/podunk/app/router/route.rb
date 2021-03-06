module Podunk
  class App
    module Router
      class Route
        def self.init_routes!
          @@routes = Hash.new {|h,k| h[k]=[]}
        end
        init_routes!

        def self.root=(method)
          @@root = method
        end
        def self.root
          @@root
        end

        attr_reader :verb, :path, :method
        attr_accessor :params
        def initialize(verb, path, method)
          @verb, @path, @method = verb, path, method

          @@routes[verb] << self
        end

        def self.for(verb, path)
          routes = @@routes[verb]
          route  = routes.find {|route| route.match path}
        end

        def match(path)
          params = {}

          if path == '/'
            return OpenStruct.new method: self.class.root
          end

          request_parts = split_path(path)
          parts = request_parts.zip path_parts

          parts_match = parts.all? {|req_part, path_part|
            if req_part and path_part
              if param = path_part[%r{:(.+)},1]
                params[param] = req_part
              else
                path_part == req_part
              end
            end
          }

          if parts_match
            self.params = params
          end
        end

      private
        def path_parts
          @parts ||= split_path(@path)
        end

        def split_path(path)
          path.split('/').reject(&:empty?)         
        end
      end
    end
  end
end
