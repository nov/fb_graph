module FbGraph
  module Connections
    module Albums
      def albums(options = {})
        albums = self.connection :albums, options
        albums.map! do |album|
          Album.new album[:id], album.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def album!(options = {})
        album = post options.merge(:connection => :albums)
        Album.new album[:id], options.merge(album).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end