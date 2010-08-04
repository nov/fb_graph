module FbGraph
  module Connections
    module Links
      def links(options = {})
        links = FbGraph::Collection.new(get(options.merge(:connection => 'links')))
        links.map! do |link|
          Link.new(link.delete(:id), link.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def link!(options = {})
        link = post(options.merge(:connection => 'links'))
        Link.new(link.delete(:id), options.merge(link).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end