module Podunk
  module HTTP
    class Request
      class Params < Hash
        def initialize(opts={})
          parse_query_string opts[:query_string]
        end

        def parse_query_string(qs)
          return if qs.empty?

          pairs = qs.split('&')
          pairs.each do |pair|
            key, value = *pair.split('=')
            self[key]  = value
          end
        end
      end
    end
  end
end
