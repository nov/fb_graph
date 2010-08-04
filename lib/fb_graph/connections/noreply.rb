module FbGraph
  module Connections
    module Noreply
      def noreply(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'noreply')))
        members.map! do |member|
          User.new(member.delete(:id), member.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end