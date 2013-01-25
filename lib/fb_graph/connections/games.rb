module FbGraph
  module Connections
    module Games
      def games(options = {})
        games = self.connection :games, options
        games.map! do |game|
          Page.new game[:id], game.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end