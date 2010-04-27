module FbGraph
  module Connections
    module Links
      def links(options = {})
        links = FbGraph::Collection.new(get(options.merge(:connection => 'links')))
        links.map! do |link|
          Link.new(link.delete(:id), link)
        end
      end
    end
  end
end