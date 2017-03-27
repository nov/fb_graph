if RUBY_VERSION >= '2.0'
  require 'cgi'
end

module FbGraph
  module Connections
    module PhotoAlbum
      def album(options = {})
        link = self.link
        album = nil
        if self.link
          if query_string = URI.parse(link).query
            query_hash = CGI.parse query_string
            if query_hash.has_key?("set")
              album_id = query_hash["set"].first.split('.')[1]
              album = ::FbGraph::Album.new(album_id, :access_token => options[:access_token] || self.access_token )
            end
          end
        end
        album
      end
    end
  end
end