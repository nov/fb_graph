module FbGraph
  module Connections
    module Videos
      def videos(options = {})
        videos = FbGraph::Collection.new(get(options.merge(:connection => 'videos')))
        videos.map! do |video|
          Video.new(video.delete(:id), video.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end