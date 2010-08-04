module FbGraph
  module Connections
    module Maybe
      def maybe(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'maybe')))
        members.map! do |member|
          User.new(member.delete(:id), member.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def maybe!(options = {})
        post(options.merge(:connection => 'maybe'))
      end
    end
  end
end