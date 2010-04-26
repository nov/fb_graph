module FbGraph
  module Connections
    module Movies
      def movies(options = {})
        movies = Collection.new(get(options.merge(:connection => 'movies')))
        movies.map! do |movie|
          Page.new(movie.delete(:id), movie)
        end
      end
    end
  end
end