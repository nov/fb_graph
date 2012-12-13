if RUBY_VERSION >= '1.9'
  require 'cover_me'
end

require 'rspec'
require 'fb_graph'
require 'fb_graph/mock'
include FbGraph::Mock
WebMock.disable_net_connect!

# Where custom mock json objects are
MOCK_JSON_DIR = File.join(File.dirname(__FILE__), 'mock_json')