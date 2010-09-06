=begin rdoc

== Fetching Wall posts

=== User Wall

  FbGraph::User.new(username).feed
  # => Array of FbGraph::Post

=== Page Wall

  FbGraph::Page.new(page_id).feed
  # => Array of FbGraph::Post

=== Application Wall

  FbGraph::Application.new(page_id).feed
  # => Array of FbGraph::Post

=== Event Wall

  FbGraph::Event.new(page_id).feed
  # => Array of FbGraph::Post

=== Group Wall

  FbGraph::Group.new(page_id).feed
  # => Array of FbGraph::Post

== Updating Wall

See details here: http://developers.facebook.com/docs/reference/api/post

=== User Wall

  me = FbGraph::User.me(ACCESS_TOKEN)
  me.feed!(
    :message => 'Updating via FbGraph',
    :picture => 'https://graph.facebook.com/matake/picture',
    :link => 'http://github.com/nov/fb_graph',
    :name => 'FbGraph',
    :description => 'A Ruby wrapper for Facebook Graph API'
  )

=== Page Wall

  page = FbGraph::Page.new(page_id)
  page.feed!(
    :access_token => ACCESS_TOKEN,
    :message => 'Updating via FbGraph',
    :picture => 'https://graph.facebook.com/matake/picture',
    :link => 'http://github.com/nov/fb_graph',
    :name => 'FbGraph',
    :description => 'A Ruby wrapper for Facebook Graph API'
  )

* You need the page admin's access_token
=end

module FbGraph::Connections::Feed
  def feed(options = {})
    posts = self.connection(:feed, options)
    posts.map! do |post|
      Post.new(post.delete(:id), post.merge(
        :access_token => options[:access_token] || self.access_token
      ))
    end
  end

  def feed!(options = {})
    post = post(options.merge(:connection => 'feed'))
    Post.new(post.delete(:id), options.merge(post).merge(
      :access_token => options[:access_token] || self.access_token
    ))
  end
end