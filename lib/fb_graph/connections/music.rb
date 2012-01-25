module FbGraph
  module Connections
    module Music
      def music(options = {})
        music = self.connection :music, options
        music.map! do |_music_|
          Page.new _music_[:id], _music_.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end