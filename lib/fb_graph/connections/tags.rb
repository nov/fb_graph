module FbGraph
  module Connections
    module Tags
      def tags(options = {})
        tags = self.connection :tags, options
        if tags.first.is_a?(Tag)
          tags
        else
          tags.map! do |tag|
            tag[:access_token] ||= options[:access_token] || self.access_token
            Tag.new tag
          end
        end
      end

      module Taggable
        def tag!(options = {})
          post options.merge(:connection => :tags)
        end
      end
    end
  end
end