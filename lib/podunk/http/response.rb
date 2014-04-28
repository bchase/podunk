module Podunk::HTTP
  class Response < Array
    attr_reader :body
    def initialize(body_value)
      set_body(body_value)
      super [ status, headers, body ]
    end

    def status
      200
    end

    def headers
      { 'Content-Type' => 'text/html' }
    end

  private
    def set_body(body)
      body  = body.empty? ? [ '' ] : body
      body  = body.respond_to?(:each) ? body : [ body ]
      @body = body
    end
  end
end
