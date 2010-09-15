module FbGraph
  class Collection < Array
    attr_reader :previous, :next, :total_count

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
        raise "Invalid collection"
      end
      result = replace(collection[:data])
      @total_count = collection[:count]
      @previous, @next = {}, {}
      if (paging = collection[:paging])
        if paging[:previous]
          @previous = fetch_params(paging[:previous])
        end
        if paging[:next]
          @next = fetch_params(paging[:next])
        end
      end
    end

    private

    def fetch_params(url)
      query = URI.parse(url).query
      params = {}
      query.split('&').each do |q|
        key, value = q.split('=')
        params[key] = URI.unescape(value)
      end
      params.delete_if do |k, v|
        !['limit', 'offset', 'until', 'since'].include?(k)
      end
    end
  end
end