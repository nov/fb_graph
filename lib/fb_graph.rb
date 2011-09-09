require 'httpclient'
require 'rack/oauth2'
require 'patch/rack/oauth2/util'

module FbGraph
  ROOT_URL = "https://graph.facebook.com"

  def self.logger
    @@logger
  end
  def self.logger=(logger)
    @@logger = logger
  end
  self.logger = Logger.new(STDOUT)
  self.logger.progname = 'Paypal::Express'

  def self.debugging?
    @@debugging
  end
  def self.debugging=(boolean)
    @@debugging = boolean
  end
  def self.debug!
    self.debugging = true
  end
  def self.debug(&block)
    original = self.debugging?
    self.debugging = true
    yield
  ensure
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
require 'fb_graph/ad_account'
require 'fb_graph/ad_campaign'
require 'fb_graph/ad_campaign_stat'
require 'fb_graph/ad_group'
require 'fb_graph/ad_group_stat'
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
require 'fb_graph/test_user' # Load after FbGraph::User
require 'fb_graph/video'

require 'fb_graph/klass'
require 'fb_graph/project'

require 'fb_graph/query'
