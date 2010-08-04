module FbGraph
  module Connections
    module Interests
      def interests(options = {})
        interests = FbGraph::Collection.new(get(options.merge(:connection => 'interests')))
        interests.map! do |interest|
          Page.new(interest.delete(:id), interest.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end