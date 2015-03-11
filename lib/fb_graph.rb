require 'httpclient'
require 'rack/oauth2'
require 'patch/rack/oauth2/util'
require 'patch/rack/oauth2/client'
require 'patch/rack/oauth2/access_token'


module FbGraph
  VERSION = ::File.read(
    ::File.join(::File.dirname(__FILE__), '../VERSION')
  ).delete("\n\r")
  ROOT_URL = 'https://graph.facebook.com'

  def self.v1!
    @v2 = false
  end
  def self.v2!
    @v2 = true
  end
  def self.v1?
    !v2?
  end
  def self.v2?
    !!@v2
  end
  def self.root_url
    if self.v2?
      File.join(ROOT_URL, 'v2.2')
    else
      ROOT_URL
    end
  end

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

  def self.http_client
    _http_client_ = HTTPClient.new(
      :agent_name => "FbGraph (#{VERSION})"
    )
    _http_client_.request_filter << RequestFilters::Scrubber.new
    _http_client_.request_filter << RequestFilters::Debugger.new if debugging?
    http_config.try(:call, _http_client_)
    _http_client_
  end
  def self.http_config(&block)
    Rack::OAuth2.http_config &block unless Rack::OAuth2.http_config
    @@http_config ||= block
  end
end

require 'fb_graph/exception'
require 'fb_graph/request_filters'

require 'fb_graph/auth'
require 'fb_graph/comparison'
require 'fb_graph/serialization'
require 'fb_graph/collection'
require 'fb_graph/connection'
require 'fb_graph/connections'
require 'fb_graph/searchable'

require 'fb_graph/action'
require 'fb_graph/age_range'
require 'fb_graph/device'
require 'fb_graph/education'
require 'fb_graph/location'
require 'fb_graph/picture'
require 'fb_graph/poke'
require 'fb_graph/privacy'
require 'fb_graph/role'
require 'fb_graph/subscription'
require 'fb_graph/targeting'
require 'fb_graph/venue'
require 'fb_graph/work'

require 'fb_graph/node'
require 'fb_graph/open_graph'
require 'fb_graph/achievement'
require 'fb_graph/ad_account'
require 'fb_graph/ad_campaign_group'
require 'fb_graph/ad_campaign'
require 'fb_graph/ad_campaign_stat'
require 'fb_graph/ad_connection_object'
require 'fb_graph/ad_creative'
require 'fb_graph/ad_group'
require 'fb_graph/ad_group_stat'
require 'fb_graph/ad_keyword'
require 'fb_graph/ad_image'
require 'fb_graph/ad_keyword_suggestion'
require 'fb_graph/ad_keyword_valid'
require 'fb_graph/broad_targeting_category'
require 'fb_graph/reach_estimate.rb'
require 'fb_graph/ad_preview.rb'
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
require 'fb_graph/milestone'
require 'fb_graph/note'
require 'fb_graph/notification'
require 'fb_graph/order'
require 'fb_graph/page'
require 'fb_graph/photo'
require 'fb_graph/cover'
require 'fb_graph/place'
require 'fb_graph/post'
require 'fb_graph/promotable_post'
require 'fb_graph/property'
require 'fb_graph/question'
require 'fb_graph/question_option'
require 'fb_graph/score'
require 'fb_graph/status'
require 'fb_graph/tab'
require 'fb_graph/tag'
require 'fb_graph/tagged_object'
require 'fb_graph/thread'
require 'fb_graph/user'
require 'fb_graph/user_achievement'
require 'fb_graph/video'
require 'fb_graph/offer'
require 'fb_graph/review'

# Load after FbGraph::User
require 'fb_graph/ad_user'
require 'fb_graph/test_user'

require 'fb_graph/klass'
require 'fb_graph/project'

require 'fb_graph/query'

require 'patch/rack/oauth2/access_token/introspectable'
