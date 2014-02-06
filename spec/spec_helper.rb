require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

require 'rspec'
require 'fb_graph'
require 'fb_graph/mock'
include FbGraph::Mock
WebMock.disable_net_connect!