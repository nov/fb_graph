module FbGraph
  class Collection < Array
    attr_reader :previous, :next, :total_count, :unread_count, :updated_time, :cursors

    def initialize(collection = nil)
      collection = case collection
      when Array
        {:data => collection, :count => collection.size}
      when Hash
        collection[:data] ||= []
        collection
      when nil
        collection = {:data => [], :count => 0}
      else
        raise ArgumentError.new("Invalid collection")
      end

      # NOTE: Graph API returns {"data":{"to":[null]}} sometimes... :(
      collection[:data].delete_if(&:nil?)

      replace collection[:data]

      if (summary = collection[:summary]).present?
        @total_count = summary[:total_count]
        @unread_count = summary[:unread_count]
        @updated_time = Time.parse(summary[:updated_time]) if summary[:updated_time]
      else
        @total_count = collection[:count]
      end
      @previous, @next, @cursors = {}, {}, {}
      if (paging = collection[:paging])
        if paging[:previous]
          @previous = fetch_params(paging[:previous])
        end
        if paging[:next]
          @next = fetch_params(paging[:next])
        end
        if paging[:cursors]
          @cursors[:after] = paging[:cursors].try(:[], :after)
          @cursors[:before] = paging[:cursors].try(:[], :before)
        end
      end
    end

    private

    def fetch_params(url)
      query = Rack::Utils.parse_nested_query(
        URI.unescape(URI.parse(URI.encode(url)).query)
      )
      params = {}
      query.each do |key, value|
        params[key.to_sym] = value
      end
      params
    end
  end
end
