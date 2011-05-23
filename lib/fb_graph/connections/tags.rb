module FbGraph
  module Connections
    module Tags
      def tags(options = {})
        tags = if @_tags_ && options.blank?
          self.connection(:tags, options.merge(:cached_collection => @_tags_))
        else
          self.connection(:tags, options)
        end
        tags.map! do |tag|
          tag[:access_token] ||= options[:access_token] || self.access_token
          Tag.new(tag)
        end
      end
    end
  end
end