module FbGraph
  class Collection < Array
    attr_reader :previous, :next

    def initialize(collection)
      # allow nil input
      collection ||= {}
      collection[:data] ||= []

      result = replace(collection[:data])
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