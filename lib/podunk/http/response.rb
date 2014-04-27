module Podunk::HTTP
  class Response < Array
    def initialize(body)
      body = body.empty? ? self.body : body
      super [ status, headers, body ]
    end

    def status
      200
    end

    def headers
      { 'Content-Type' => 'text/text' }
    end

    def body
      [ ]
    end
  end
end
