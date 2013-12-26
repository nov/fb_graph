module FbGraph
  module RequestFilters
    class Scrubber
      def filter_request(request)
        # nothing to do
      end

      def filter_response(request, response)
        response.body.scrub! if response.body.respond_to?(:scrub!)
      end
    end
  end
end