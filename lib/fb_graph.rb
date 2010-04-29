require 'rubygems'
require 'json'
require 'active_support'
require 'restclient'

module FbGraph
  ROOT_URL = "https://graph.facebook.com"

  class FbGraph::Exception < StandardError
    attr_accessor :code, :message, :body
    def initialize(code, message, body = '')
      @code = code
      @message = message
      @body = body
    end
  end
  class FbGraph::Unauthorized < FbGraph::Exception; end
  class FbGraph::NotFound < FbGraph::Exception; end

  class << self
    def node(identifier, options = {})
      Node.new(identifier, options)
    end
    def user(identifier, options = {})
      User.new(identifier, options)
    end
  end

end

require 'fb_graph/comparison'
require 'fb_graph/collection'
require 'fb_graph/connections'

require 'fb_graph/node'
require 'fb_graph/album'
require 'fb_graph/event'
require 'fb_graph/group'
require 'fb_graph/link'
require 'fb_graph/note'
require 'fb_graph/page'
require 'fb_graph/photo'
require 'fb_graph/post'
require 'fb_graph/status'
require 'fb_graph/tag'
require 'fb_graph/user'
require 'fb_graph/venue'
require 'fb_graph/video'
