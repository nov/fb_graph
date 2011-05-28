module FbGraph
  module Connections
    module Tags
      def tags(options = {})
        tags = if @_tags_ && options.blank?
          return @_tags_ if @_tags_.first.is_a?(Tag)
          self.connection(:tags, options.merge(:cached_collection => @_tags_))
        else
          self.connection(:tags, options)
        end
        tags.map! do |tag|
          tag[:access_token] ||= options[:access_token] || self.access_token
          Tag.new(tag)
        end
      end

      module Taggable
        def tag!(options = {})
          post(options.merge(:connection => :tags))
        end
      end
    end
  end
end