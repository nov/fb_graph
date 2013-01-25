module FbGraph
  class UserAchievement < Node
    include Connections::Comments
    include Connections::Likes
    include Connections::Likes::Likable

    attr_accessor :from, :created_time, :application, :achievement

    def initialize(identifier, attributes = {})
      super

      if from = attributes[:from]
        @from = User.new(from[:id], from)
      end
      if created_time = attributes[:created_time] || attributes[:publish_time]
        @created_time = Time.parse(created_time).utc
      end
      if application = attributes[:application]
        application[:link] = application[:url] # for some reason, FB uses "url" only here..
        @application = Application.new(application[:id], application)
      end
      if achievement = attributes[:achievement]
        @achievement = Achievement.new(achievement[:id], achievement)
      end

      # cached connection
      cache_collections attributes, :comments, :likes
    end

    def destroy(options = {})
      options[:access_token] ||= self.access_token
      from.unachieve!(achievement.url, options)
    end
  end
end