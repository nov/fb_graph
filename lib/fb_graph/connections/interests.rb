module FbGraph
  module Connections
    module Interests
      def interests(options = {})
        interests = Collection.new(get(options.merge(:connection => 'interests')))
        interests.map! do |interest|
          Page.new(interest.delete(:id), interest)
        end
      end
    end
  end
end