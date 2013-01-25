module FbGraph
  module Connections
    module Checkins
      def checkins(options = {})
        checkins = self.connection :checkins, options
        checkins.map! do |checkin|
          Checkin.new checkin[:id], checkin.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def checkin!(options = {})
        checkin = post options.merge(:connection => :checkins)
        Checkin.new checkin[:id], options.merge(checkin).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end
