module FbGraph 
  module Connections
    module AdImages

      def ad_images(options = {})
        ad_images = self.connection(:adimages, options)
        ad_images.map! do |ad_image|
          AdImage.new(ad_image[:hash], ad_image.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def ad_image!(options = {})
        raise "Invalid file option, must have :file as key" if options[:file].empty?
        raise "Image file not found" unless File.exist?(options[:file])
        options[:file] = File.open(options[:file])
        ad_image = post(options.merge(:connection => :adimages))
        fb_data = ad_image[:images]? ad_image[:images].values.first.symbolize_keys : ad_image
        AdImage.new(fb_data[:hash], options.merge( fb_data ).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end

    end
  end
end
