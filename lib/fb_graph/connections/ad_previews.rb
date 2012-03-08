module FbGraph
  module Connections
    module AdPreviews
      def ad_previews(options = {})
        ad_previews = self.post options.merge(:method => 'get', :connection => :generatepreviews)
        AdPreview.new ad_previews.merge(:access_token => options[:access_token] || self.access_token)
      end
    end
  end
end
