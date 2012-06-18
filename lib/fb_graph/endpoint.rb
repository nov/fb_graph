module FbGraph
  class Endpoint < Array
    def initialize(relative_url, params = {})
      @relative_url = relative_url || []
      @params = params
      @query_string=''
    end
    def relative_url
      "#{File.join(@relative_url).to_s}#{@params[:access_token] ? "?access_token=#{@params[:access_token]}" : ''}"
    end
    def query_string=(string)
      @query_string="?#{string}"
    end
    def to_s
      "#{File.join([ROOT_URL,  @relative_url])}#@query_string"
    end
  end
end
