module FbGraph
  module Connections
    module Videos
      def videos(options = {})
        videos = self.connection(:videos, options)
        videos.map! do |video|
          Video.new(video[:id], video.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end