module FbGraph
  module Connections
    module Likes
      def likes(options = {})
        @likes ||= get(options.merge(:connection => 'likes'))
        pages = []
        @likes[:data].each do |like|
          pages << Page.new(like[:id], :name => like[:name], :category => like[:category])
        end
        pages
      end
    end
  end
end