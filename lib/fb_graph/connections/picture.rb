module FbGraph
  module Connections
    module Picture
      # User can specify size in two ways: 
      # 1. By type: square | small | normal | large
      # 2. By width and height, so facebook return the _closest_
      #    match to the size you specified, if only one parameter
      #    is set, then facebook will return square image
      # See: https://developers.facebook.com/docs/reference/api/user/
      def picture(size_or_width = nil, height = nil)        
        params = {}
        if size_or_width.kind_of? String or size_or_width.kind_of? Symbol
          params[:type]   = size_or_width
        elsif size_or_width.kind_of? Fixnum or not height.nil?
          params[:width]  = size_or_width  unless size_or_width.nil?
          params[:height] = height         unless height.nil?
        end
        params = params.empty? ? '' : "?#{encode_www_form params}"

        # TODO: it's better to use URI.join here
        "#{self.endpoint}/picture#{params}"
      end

      private

      # URI.encode_www_form is Ruby >= 1.9 specific function
      def encode_www_form(params)
        if URI.respond_to? 'encode_www_form'
          URI.encode_www_form params
        else
          params.map {|k,v| "#{CGI.escape k.to_s}=#{CGI.escape v.to_s}"}.join('&')
        end
      end
    end
  end
end