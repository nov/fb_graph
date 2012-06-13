module FbGraph
  class Endpoint < Array
    def initialize(relative_url)
      @relative_url = relative_url || []
    end
    def relative_url
      File.join @relative_url
    end
    def to_s
      File.join [FbGraph::ROOT_URL, @relative_url]
    end
  end
end
