module FbGraph
  module Connections
    module AdImages
      def ad_images(options = {})
        ad_images = self.connection :adimages, options
        ad_images.map! do |ad_image|
          AdImage.new ad_image[:id], ad_image.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def ad_image!(options = {})
        ad_image = post options.merge(:connection => :adimages)

       # No ID is contained in the response.
        adimage_id = ad_image[:images].keys.first
        hash = ad_image[:images].values.first[:hash]
        url = ad_image[:images].values.first[:url]

        merged_attrs = options.merge(
          :access_token => options[:access_token] || self.access_token,
          :hash => hash,
          :url => url
        )

        if options[:redownload]
          merged_attrs = merged_attrs.merge(ad_image[:data][:adimages][adimage_id]).with_indifferent_access
        end
	
	# The first argument is the identifier, which is appended to the endpoint
        AdImage.new adimage_id, merged_attrs
      end
    end
  end
end
