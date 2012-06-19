module FbGraph
  module Connections
    module Achievements
      def achievements(options = {}, &block)
        self.map_connection :achievements, options, Achievement, &block
      end

      def achievement!(achievement_url, options = {}, &block)
        post options.merge(:connection => :achievements, :achievement => achievement_url), &block
      end

      def unregister_achievement!(achievement_url, options = {}, &block)
        delete options.merge(:connection => :achievements, :achievement => achievement_url), &block
      end
    end
  end
end
