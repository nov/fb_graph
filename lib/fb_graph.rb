require 'rubygems'
require 'json'
require 'active_support'
require 'rest_client'

module FbGraph
  ROOT_URL = "https://graph.facebook.com"

  class FbGraph::Exception < StandardError; end
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

Dir[File.dirname(__FILE__) + '/fb_graph/*.rb'].each do |file| 
  require file
end