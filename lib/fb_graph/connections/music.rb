module FbGraph
  module Connections
    module Music
      def music(options = {})
        music = FbGraph::Collection.new(get(options.merge(:connection => 'music')))
        music.map! do |_music_|
          Page.new(_music_.delete(:id), _music_)
        end
      end
    end
  end
end