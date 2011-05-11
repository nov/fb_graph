module FbGraph
  module Connections
    module Picture
      def picture(size = nil)
        _endpoint_ = "#{self.endpoint}/picture"
        if size
          _endpoint_ += "?type=#{size}"
        end
        _endpoint_
      end
    end
  end
end