$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

if RUBY_VERSION >= '1.9'
  require 'cover_me'
end

require 'fb_graph'
require 'rspec'
require 'helpers/webmock_helper'