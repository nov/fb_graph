module FbGraph
  class Endpoint < Array
    def initialize(relative_url, params = {})
      @relative_url = relative_url || []
      @params = params
    end
    def relative_url
      "#{File.join(@relative_url).to_s}#{@params[:access_token] ? "?access_token=#{@params[:access_token]}" : ''}"
    end
    def to_s
      File.join [FbGraph::ROOT_URL, @relative_url]
    end
  end
end
