module FbGraph
  module Connections
    module Movies
      def movies(options = {})
        movies = FbGraph::Collection.new(get(options.merge(:connection => 'movies')))
        movies.map! do |movie|
          Page.new(movie.delete(:id), movie.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end