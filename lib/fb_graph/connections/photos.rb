module FbGraph
  module Connections
    module Photos
      def photos(options = {})
        photos = self.connection :photos, options
        photos.map! do |photo|
          Photo.new photo[:id], photo.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def photo!(options = {})
        photo = post options.merge(:connection => :photos)
        Photo.new photo[:id], options.merge(photo).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end