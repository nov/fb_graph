module FbGraph
  module Connections
    # = Authentication
    #
    # * Access token required to fetch/create albums.
    # * "publish_stream" permissin is required to create new album.
    #
    # = Connected with
    #
    # * FbGraph::Application
    # * FbGraph::USer
    # * FbGraph::Page
    #
    # = Example
    #
    # == Fetch albums
    #
    #   me = FbGraph::User.me(ACCESS_TOKEN)
    #   me.albums
    #   # => Array of FbGraph::Album
    #
    #   page = FbGraph::Page.new('fb_graph')
    #   page.albums
    #   # => Array of FbGraph::Album
    #
    # == Create an album
    #
    #   me = FbGraph::User.me(ACCESS_TOKEN)
    #   album = me.album!(
    #     :name => 'FbGraph test',
    #     :message => 'hello world!',
    #     :description => 'hello world!'
    #   )
    #
    #   page = FbGraph::Page.new('fb_graph', :access_token => ACCESS_TOKEN)
    #   album = page.album!(
    #     :name => 'FbGraph test',
    #     :message => 'hello world!',
    #     :description => 'hello world!'
    #   )
    #
    # = Notes
    #
    # == Attributes after created
    #
    # Only attributes you specified are saved in the created album object.
    # If you want to access any other attributes, you need to fetch the album info via Graph API.
    #
    #   me = FbGraph::User.me(ACCESS_TOKEN)
    #   album = me.album!(
    #     :name => 'FbGraph test',
    #     :message => 'hello world!',
    #     :description => 'hello world!'
    #   )
    #   album.name # => 'FbGraoh test'
    #   album.from # => nil
    #   album.created_time # => nil
    #   album.fetch
    #   album.from # => me
    #   album.created_time # => Sun Sep 12 01:18:36 +0900 2010
    #
    # == Bug of Graph API
    #
    # According facebook's document, the key for +description+ should be +description+ both when fetching and creating,
    # but actually you need to use +message+ instead of +description+ only when creating.
    # It probably facebook's bug, and it might be fixed suddenly.
    # I highly recommend to send same value both as +description+ and +message+ when creating,
    # then your code will work without any code change.
    #
    # ref) http://developers.facebook.com/docs/reference/api/album
    #
    #   me = FbGraph::User.me(ACCESS_TOKEN)
    #   album = me.album!(
    #     :name => 'FbGraph test',
    #     :message => 'hello world!',
    #     :description => 'hello world!'
    #   )
    module Albums
      def albums(options = {})
        albums = self.connection(:albums, options)
        albums.map! do |album|
          Album.new(album.delete(:id), album.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def album!(options = {})
        album = post(options.merge(:connection => 'albums'))
        Album.new(album.delete(:id), options.merge(album).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end