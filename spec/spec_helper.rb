$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'fb_graph'
require 'fakeweb'
require 'helpers/fake_json_helper'
include FakeJsonHelper
FakeWeb.allow_net_connect = false