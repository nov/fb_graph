module FbGraph
  module Connections
    module FormerParticipants
      def former_participants(options = {})
        users = if @_former_participants_ && options.blank?
          self.connection(:former_participants, options.merge(:cached_collection => @_former_participants_))
        else
          self.connection(:former_participants, options)
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