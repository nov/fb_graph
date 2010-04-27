module FbGraph
  module Connections
    module Photos
      def photos(options = {})
        photos = FbGraph::Collection.new(get(options.merge(:connection => 'photos')))
        photos.map! do |photo|
          Photo.new(photo.delete(:id), photo)
        end
      end
    end
  end
end