module FbGraph
  module Connections
    module Picture
      def picture(size = nil)
        _endpoint_ = "#{self.endpoint}/picture"
        if size
          _endpoint_ += "?type=#{size}"
          _endpoint_ += "&access_token=#{self.access_token}" if self.access_token
        else
          _endpoint_ += "?access_token=#{self.access_token}" if self.access_token
        end
        _endpoint_
      end
    end
  end
end