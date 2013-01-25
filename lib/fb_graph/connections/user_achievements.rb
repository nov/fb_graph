module FbGraph
  module Connections
    module UserAchievements
      def achievements(options = {})
        options[:access_token] ||= self.access_token
        achievements = self.connection :achievements, options
        achievements.map! do |achievement|
          UserAchievement.new achievement[:id], achievement.merge(:access_token => options[:access_token])
        end
      end

      def achieve!(achievement_url, options = {})
        achievement = post options.merge(:connection => :achievements, :achievement => achievement_url)
        UserAchievement.new achievement[:id], achievement
      end

      def unachieve!(achievement_url, options = {})
        delete options.merge(:connection => :achievements, :achievement => achievement_url)
      end
    end
  end
end