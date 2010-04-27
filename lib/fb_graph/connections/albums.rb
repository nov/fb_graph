module FbGraph
  module Connections
    module Albums
      def albums(options = {})
        albums = FbGraph::Collection.new(get(options.merge(:connection => 'albums')))
        albums.map! do |album|
          Album.new(album.delete(:id), album)
        end
      end
    end
  end
end