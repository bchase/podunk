require 'podunk/http'
require 'podunk/app/router'

module Podunk
  class App
    include Router
    route do
      get '/favicon.ico' => 'favicon'
    end

    def favicon
      [ '' ]
    end

    def body
      [ 'Welcome to Podunk!' ]
    end

    def response
      body = render_body_for_route
      HTTP::Response.new body
    end

    attr_reader :request, :params
    def call(env)
      @request = HTTP::Request.new env
      @params  = @request.params
      response
    end
  end
end
