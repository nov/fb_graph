module FbGraph
  module Connections
    module Achievements
      def achievements(options = {})
        options[:access_token] ||= self.access_token
        achievements = self.connection(:achievements, options)
        achievements.map! do |achievement|
          Achievement.new(achievement[:id], achievement.merge(:access_token => options[:access_token]))
        end
      end
    end
  end
end