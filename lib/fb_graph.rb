require 'rubygems'
require 'json'
require 'httpclient'
require 'oauth2'
require 'active_support/all'

module FbGraph
  ROOT_URL = "https://graph.facebook.com"

  class Exception < StandardError
  end

  class APIError < Exception
    attr_accessor :status, :type
    alias code status
    def initialize(status, message, body = nil)
      super message
      @status = status
      if body.present?
        response = JSON.parse(body).with_indifferent_access
        @message = response[:error][:message]
        @type = response[:error][:type]
      end
    end
  end

  class BadRequest < APIError
    def initialize(message, body = '')
      super 400, message, body
    end
  end

  class Unauthorized < APIError
    def initialize(message, body = '')
      super 401, message, body
    end
  end

  class NotFound < APIError
    def initialize(message, body = '')
      super 404, message, body
    end
  end

end

require 'fb_graph/auth'
require 'fb_graph/comparison'
require 'fb_graph/serialization'
require 'fb_graph/collection'
require 'fb_graph/connection'
require 'fb_graph/connections'
require 'fb_graph/searchable'

require 'fb_graph/action'
require 'fb_graph/education'
require 'fb_graph/location'
require 'fb_graph/privacy'
require 'fb_graph/subscription'
require 'fb_graph/targeting'
require 'fb_graph/venue'
require 'fb_graph/work'

require 'fb_graph/node'
require 'fb_graph/album'
require 'fb_graph/app_request'
require 'fb_graph/application'
require 'fb_graph/checkin'
require 'fb_graph/comment'
require 'fb_graph/event'
require 'fb_graph/friend_list'
require 'fb_graph/group'
require 'fb_graph/insight'
require 'fb_graph/link'
require 'fb_graph/message'
require 'fb_graph/note'
require 'fb_graph/page'
require 'fb_graph/photo'
require 'fb_graph/place'
require 'fb_graph/post'
require 'fb_graph/project'
require 'fb_graph/status'
require 'fb_graph/tag'
require 'fb_graph/test_user'
require 'fb_graph/thread'
require 'fb_graph/user'
require 'fb_graph/video'

require 'fb_graph/query'
