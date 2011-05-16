module FbGraph
  module Connections
    module Senders
      def senders(options = {})
        users = if @_senders_ && options.blank?
          self.connection(:senders, options.merge(:cached_collection => @_senders_))
        else
          self.connection(:senders, options)
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