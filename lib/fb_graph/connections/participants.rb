module FbGraph
  module Connections
    module Participants
      def participants(options = {})
        users = if @_participants_ && options.blank?
          self.connection(:participants, options.merge(:cached_collection => @_participants_))
        else
          self.connection(:participants, options)
        end
        users.map! do |user|
          User.new(user[:id], user.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end