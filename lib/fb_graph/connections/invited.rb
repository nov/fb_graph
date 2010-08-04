module FbGraph
  module Connections
    module Invited
      def invited(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'invited')))
        members.map! do |member|
          User.new(member.delete(:id), member.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end