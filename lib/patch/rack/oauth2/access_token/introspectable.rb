module Rack
  module OAuth2
    class AccessToken
      module Introspectable
        class Result < FbGraph::Node
          ATTRIBUTES = [:application, :user, :expires_at, :issued_at, :is_valid, :metadata, :scopes, :error]
          attr_accessor *ATTRIBUTES

          def initialize(identifier = nil, attributes = {})
            super :debug_token, attributes
            if (data = attributes[:data])
              @application = FbGraph::Application.new data[:app_id], :name => data[:application]
              @user        = FbGraph::User.new data[:user_id]
              @expires_at  = Time.at data[:expires_at]
              @issued_at   = Time.at data[:issued_at] if data[:issued_at]
              (ATTRIBUTES - [:application, :user, :expires_at, :issued_at]).each do |key|
                self.send :"#{key}=", data[key]
              end
            end
          end
        end

        def self.included(klass)
          klass.send :attr_accessor, *Result::ATTRIBUTES
        end

        def introspect(app_token)
          Result.new.fetch(
            :access_token => app_token,
            :input_token => access_token
          )
        end
      end
      AccessToken.send :include, Introspectable
    end
  end
end
