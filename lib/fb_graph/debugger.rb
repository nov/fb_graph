module Debugger
  class RequestFilter
    def initialize(node)
      @node = node
    end

    # Callback called in HTTPClient (before sending a request)
    # request:: HTTP::Message
    def filter_request(request)
      FbGraph.logger.info <<-LOG
# START API REQUEST
#{request.method.upcase} #{request.path}
Host: #{request.host}
LOG
      request
    end

    # Callback called in HTTPClient (after received a response)
    # response:: HTTP::Message
    # request::  HTTP::Message
    def filter_response(response, request)
      # nothing to do
    end
  end
end