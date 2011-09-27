require 'httpclient'
require 'rack/oauth2'
require 'patch/rack/oauth2/util'

module FbGraph
  VERSION = ::File.read(
    ::File.join(::File.dirname(__FILE__), '../VERSION')
  )
  ROOT_URL = "https://graph.facebook.com"

  def self.logger
    @@logger
  end
  def self.logger=(logger)
    @@logger = logger
  end
  self.logger = Logger.new(STDOUT)
  self.logger.progname = 'FbGraph'

  def self.debugging?
    @@debugging
  end
  def self.debugging=(boolean)
    Rack::OAuth2.debugging = boolean
    @@debugging = boolean
  end
  def self.debug!
    Rack::OAuth2.debug!
    self.debugging = true
  end
  def self.debug(&block)
    rack_oauth2_original = Rack::OAuth2.debugging?
    original = self.debugging?
    debug!
    yield
  ensure
    Rack::OAuth2.debugging = rack_oauth2_original
    self.debugging = original
  end
  self.debugging = false
end

require 'fb_graph/exception'
require 'fb_graph/debugger'

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
require 'fb_graph/achievement'
require 'fb_graph/ad_account'
require 'fb_graph/ad_campaign'
require 'fb_graph/ad_campaign_stat'
require 'fb_graph/ad_connection_object'
require 'fb_graph/ad_group'
require 'fb_graph/ad_group_stat'
require 'fb_graph/ad_keyword'
require 'fb_graph/ad_keyword_suggestion'
require 'fb_graph/ad_keyword_valid'
require 'fb_graph/broad_targeting_category'
require 'fb_graph/reach_estimate.rb'
require 'fb_graph/album'
require 'fb_graph/app_request'
require 'fb_graph/application'
require 'fb_graph/checkin'
require 'fb_graph/comment'
require 'fb_graph/doc'
require 'fb_graph/domain'
require 'fb_graph/event'
require 'fb_graph/friend_list'
require 'fb_graph/friend_request'
require 'fb_graph/group'
require 'fb_graph/image'
require 'fb_graph/insight'
require 'fb_graph/link'
require 'fb_graph/message'
require 'fb_graph/note'
require 'fb_graph/order'
require 'fb_graph/page'
require 'fb_graph/photo'
require 'fb_graph/place'
require 'fb_graph/post'
require 'fb_graph/property'
require 'fb_graph/review'
require 'fb_graph/status'
require 'fb_graph/tab'
require 'fb_graph/tag'
require 'fb_graph/thread'
require 'fb_graph/user'
require 'fb_graph/user_achievement'
require 'fb_graph/video'

# Load after FbGraph::User
require 'fb_graph/ad_user'
require 'fb_graph/test_user'

require 'fb_graph/klass'
require 'fb_graph/project'

require 'fb_graph/query'
