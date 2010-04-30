module FbGraph
  module Connections
    module Photos
      def photos(options = {})
        photos = FbGraph::Collection.new(get(options.merge(:connection => 'photos')))
        photos.map! do |photo|
          Photo.new(photo.delete(:id), photo)
        end
      end

      def photo!(options = {})
        photo = post(options.merge(:connection => 'photos'))
        Photo.new(photo.delete(:id), options.merge(photo))
      end
    end
  end
end