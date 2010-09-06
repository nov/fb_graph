module FbGraph
  module Connections
    # = Page (wall post)
    module Feed
      def feed(options = {})
        posts = self.connection(:feed, options)
        posts.map! do |post|
          Post.new(post.delete(:id), post.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      # == Update User Wall
      # 
      # me = FbGraph::User.me(ACCESS_TOKEN)
      # me.feed!(
      #   :message => 'Updating via FbGraph',
      #   :picture => 'https://graph.facebook.com/matake/picture',
      #   :link => 'http://github.com/nov/fb_graph',
      #   :name => 'FbGraph',
      #   :description => 'A Ruby wrapper for Facebook Graph API'
      # )
      # 
      # == Update Page Wall
      # <em>NOTE: you need the page admin's access_token</em>
      # 
      # page = FbGraph::Page.new(page_id, :access_token => ACCESS_TOKEN)
      # page.feed!(
      #   :message => 'Updating via FbGraph',
      #   :picture => 'https://graph.facebook.com/matake/picture',
      #   :link => 'http://github.com/nov/fb_graph',
      #   :name => 'FbGraph',
      #   :description => 'A Ruby wrapper for Facebook Graph API'
      # )
      def feed!(options = {})
        post = post(options.merge(:connection => 'feed'))
        Post.new(post.delete(:id), options.merge(post).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end