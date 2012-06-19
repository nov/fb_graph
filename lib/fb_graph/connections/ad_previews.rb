module FbGraph
  module Connections
    module AdPreviews
      def ad_previews(options = {}, &block)
        self.post options.merge(:method => 'get', :connection => :generatepreviews, :_class => Hash) do |ad_previews|
          response = AdPreview.new ad_previews.merge(:access_token => options[:access_token] || self.access_token)
          block_given? ? (yield response) : response
        end
      end
    end
  end
end
