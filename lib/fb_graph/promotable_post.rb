module FbGraph
  class PromotablePost < Post
    attr_accessor :is_published, :scheduled_publish_time

    def initialize(identifier, attributes = {})
      super
      @is_published = attributes[:is_published]
      @scheduled_publish_time = if attributes[:scheduled_publish_time]
        Time.at attributes[:scheduled_publish_time]
      end
    end

    def publishable?
      !@is_published
    end
    alias_method :schedulable?, :publishable?

    def scheduled?
      !!scheduled_publish_time
    end

    def publish!(options = {})
      update options.merge(:is_published => true)
    end

    def schedule!(time, options = {})
      update options.merge(:scheduled_publish_time => time.to_i)
    end

    def unschedule!(options = {})
      schedule! nil, options
    end
  end
end