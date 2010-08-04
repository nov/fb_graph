module FbGraph
  module Connections
    module Television
      def television(options = {})
        television = FbGraph::Collection.new(get(options.merge(:connection => 'television')))
        television.map! do |_television_|
          Page.new(_television_.delete(:id), _television_.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end