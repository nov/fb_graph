module FbGraph
  module Connections
    class Collection < Array
      attr_reader :previous, :next

      def initialize(collection)
        result = replace(collection[:data])
        @previous, @next = {}, {}
        if (paging = collection[:paging])
          if paging[:previous]
            @previous = parse_query(URI.parse(paging[:previous]).query)
          end
          if paging[:next]
            @next = parse_query(URI.parse(paging[:next]).query)
          end
        end
      end

      private

      def parse_query(query)
        params = {}
        query.split('&').each do |q|
          key, value = q.split('=')
          params[key] = value
        end
        params.with_indifferent_access
      end
    end
  end
end