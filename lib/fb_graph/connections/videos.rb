module FbGraph
  module Connections
    module Videos
      def videos(options = {})
        videos = FbGraph::Collection.new(get(options.merge(:connection => 'videos')))
        videos.map! do |video|
          Video.new(video.delete(:id), video)
        end
      end
    end
  end
end