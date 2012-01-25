module FbGraph
  module Connections
    module Links
      def links(options = {})
        links = self.connection :links, options
        links.map! do |link|
          Link.new link[:id], link.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def link!(options = {})
        link = post options.merge(:connection => :links)
        Link.new link[:id], options.merge(link).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end