module FbGraph
  module RequestFilters
    class Scrubber
      def filter_request(request)
        # nothing to do
      end

      def filter_response(request, response)
        response_body = if response.body.respond_to?(:scrub)
                          response.body.scrub
                        else
                          scrub_invalid_bytes(response.body)
                        end
        response.http_body.init_response(response_body)
      end

      private

      def scrub_invalid_bytes(string)
        string.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => "\uFFFD")
        string.encode!('UTF-8', 'UTF-16', :invalid => :replace, :replace => "\uFFFD")
        string
      end
    end
  end
end
