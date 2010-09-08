module FbGraph
  module Connections
    module Checkins
      def checkins(options = {})
        checkins = self.connection(:checkins, options)
        checkins.map! do |checkin|
          FbGraph::Checkin.new(checkin.delete(:id), checkin.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end