module FbGraph
  module Connections
    module Achievements
      def achievements(options = {})
        options[:access_token] ||= self.access_token
        achievements = self.connection :achievements, options
        achievements.map! do |achievement|
          Achievement.new achievement[:id], achievement.merge(:access_token => options[:access_token])
        end
      end

      def achievement!(achievement_url, options = {})
        post options.merge(:connection => :achievements, :achievement => achievement_url)
      end

      def unregister_achievement!(achievement_url, options = {})
        delete options.merge(:connection => :achievements, :achievement => achievement_url)
      end
    end
  end
end