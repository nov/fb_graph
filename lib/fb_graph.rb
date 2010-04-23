require 'rubygems'
require 'active_support'

module FbGraph
  ROOT_URL = "https://graph.facebook.com"

  class Exception < ::StandardError; end

  def self.node(identifier)
    Node.new(identifier)
  end

end

require 'fb_graph/node'