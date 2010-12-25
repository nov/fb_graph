module FbGraph
  module Connections
    module Feed
      # == Fetching Wall posts
      # 
      # === User Wall
      # 
      #   FbGraph::User.new(username).feed
      #   # => Array of FbGraph::Post
      # 
      # === Page Wall
      # 
      #   FbGraph::Page.new(page_id).feed
      #   # => Array of FbGraph::Post
      # 
      # === Application Wall
      # 
      #   FbGraph::Application.new(page_id).feed
      #   # => Array of FbGraph::Post
      # 
      # === Event Wall
      # 
      #   FbGraph::Event.new(page_id).feed
      #   # => Array of FbGraph::Post
      # 
      # === Group Wall
      # 
      #   FbGraph::Group.new(page_id).feed
      #   # => Array of FbGraph::Post
      def feed(options = {})
        posts = self.connection(:feed, options)
        posts.map! do |post|
          Post.new(post.delete(:id), post.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      # == Updating Wall
      # 
      # * See supported arguments here http://developers.facebook.com/docs/reference/api/post
      # * You need admin user's access_token to update Page/Application/Event/Group wall as itself
      # 
      # === User Wall
      # 
      #   me = FbGraph::User.me(ACCESS_TOKEN)
      #   me.feed!(
      #     :message => 'Updating via FbGraph'
      #   )
      # 
      # === Page Wall
      # 
      #   page = FbGraph::Page.new(page_id)
      #   page.feed!(
      #     :access_token => ACCESS_TOKEN,
      #     :message => 'Updating via FbGraph'
      #   )
      # 
      # === Application Wall
      # 
      #   application = FbGraph::Page.new(application_id)
      #   application.feed!(
      #     :access_token => ACCESS_TOKEN,
      #     :message => 'Updating via FbGraph'
      #   )
      # 
      # === Event Wall
      # 
      #   event = FbGraph::Event.new(event_id)
      #   event.feed!(
      #     :access_token => ACCESS_TOKEN,
      #     :message => 'Updating via FbGraph'
      #   )
      # 
      # === Group Wall
      # 
      #   group = FbGraph::Group.new(group_id)
      #   group.feed!(
      #     :access_token => ACCESS_TOKEN,
      #     :message => 'Updating via FbGraph'
      #   )
      def feed!(options = {})
        post = post(options.merge(:connection => :feed))
        Post.new(post.delete(:id), options.merge(post).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end