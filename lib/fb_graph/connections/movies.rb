module FbGraph
  module Connections
    module Movies
      def movies(options = {})
        movies = self.connection :movies, options
        movies.map! do |movie|
          Page.new movie[:id], movie.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end