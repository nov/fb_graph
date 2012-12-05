module FbGraph
  module Connections
    module Picture
      # User can specify size in two ways: 
      # 1. By type: square | small | normal | large
      # 2. By width and height, so facebook return the _closest_
      #    match to the size you specified, if only one parameter
      #    is set, then facebook will return square image
      # See: https://developers.facebook.com/docs/reference/api/user/
      def picture(options_or_size = {})
        options = if options_or_size.is_a?(String) || options_or_size.is_a?(Symbol)
          {:type => options_or_size}
        else
          options_or_size
        end
        _endpoint_ = ["#{self.endpoint}/picture", options.to_query].delete_if(&:blank?).join('?')

        if options[:redirect] == false
          response = get options.merge(
            :connection => :picture,

            # NOTE: can be removed when addressable 2.3.3+ released with this fix
            # https://github.com/sporkmonger/addressable/commit/421a88fed1d2f14426f15158f3712ab563581327
            :redirect => 'false'
          )
          FbGraph::Picture.new response[:data]
        else
          _endpoint_
        end
      end

      module Updatable
        def picture!(options = {})
          post options.merge(:connection => :picture)
        end
      end
    end
  end
end