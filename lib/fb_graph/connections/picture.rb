module FbGraph
  module Connections
    module Picture
      def picture(size = nil)
        picture_endpoint = "#{self.endpoint}/picture"
        if size
          "#{picture_endpoint}?type=#{size}"
        else
          picture_endpoint
        end
      end
    end
  end
end