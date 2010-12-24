module FbGraph
  # = Authentication
  #
  # * Access token is required to fetch album info.
  #
  # = Attributes
  #
  # +from+::         FbGraph::User or FbGraph::Page
  # +name+::         String
  # +description+::  String
  # +location+::     String <em>ex.) "NYC"</em>
  # +link+::         String
  # +privacy+::      String <em>ex.) "everyone"</em>
  # +count+::        Integer
  # +type+::         String <em>ex.) "normal"</em>
  # +created_time+:: Time (UTC)
  # +updated_time+:: Time (UTC)
  #
  # = Connections
  #
  # +photos+::   Array of FbGraph::Photo
  # +comments+:: Array of FbGraph::Comment
  # +likes+::    Array of FbGraph::Page
  #
  # = Examples
  #
  # == Fetch album info
  #
  #   album = FbGraph::Album.new(ALBUM_ID)
  #   album.fetch(:access_token => ACCESS_TOKEN)
  #
  # or
  #
  #   FbGraph::album.fetch(ALBUM_ID, :access_token => ACCESS_TOKEN)
  #
  # == Fetch connection
  #
  #   photos = album.photos
  #   likes = album.likes
  #   comments = album.comments
  #
  # === Pagination
  #
  #   photos = album.photos
  #   photos_next = photos.next
  #   photos_previous = photos.previous
  #   photos = album.photos(:since => '2010-09-01', :until => '2010-10-01')
  #   photos = album.photos(:offset => 20, :limit => 20)
  #
  # == Creat new album
  #
  # See RDoc for FbGraph::Connections::Albums
  #
  # == Upload a photo
  #
  #   album.photo!(
  #     :image => File.new(File.join(File.dirname(__FILE__), 'nov.gif')),
  #     :name => "name",
  #     :message => 'message'
  #   )
  #
  # == Post a comment
  #
  #   album.comment!(
  #     :access_token => ACCESS_TOKEN,
  #     :message => 'Hey, I\'m testing you!'
  #   )
  #
  # == Delete a comment
  #
  #   comment = album.comments.last
  #   comment.destroy
  #
  # == Like and unlike
  #
  #   album.like!
  #   album.unlike!
  #
  # = Notes
  #
  # == Attribute +from+
  #
  # Both facebook user and page can have albums, so +from+ can be either FbGraph::User or FbGraph::Page.
  # * When you called +ablums+ connection of FbGraph::User, all +from+ should be FbGraph::User.
  # * When you called +ablums+ connection of FbGraph::Page, all +from+ should be FbGraph::Page.
  # * When you fetched an album by objedt id, +from+ can be either FbGraph::User or FbGraph::Page.
  #
  # == Cached +comments+
  #
  # When album object fetched, several comments are included in the response.
  # So first time you called +album.comments+, those cached comments will be returned.
  # If you put any option parameter like +album.comments(:access_token => ACCESS_TOKEN)+,
  # fb_graph ignores those cached comments and fetch comments via Graph API.
  #
  # <em>If cached "album.comments" are blank, probably the album has no comments yet.</em>
  class Album < Node
    include Connections::Photos
    include Connections::Comments
    include Connections::Likes

    attr_accessor :from, :name, :description, :location, :link, :privacy, :count, :created_time, :updated_time, :type

    def initialize(identifier, attributes = {})
      super
      @from = if (from = attributes[:from])
        if from[:category]
          Page.new(from.delete(:id), from)
        else
          User.new(from.delete(:id), from)
        end
      end
      @name = attributes[:name]
      # NOTE:
      # for some reason, facebook uses different parameter names.
      # "description" in GET & "message" in POST
      # TODO:
      # check whether this issue is solved or not
      @description = attributes[:description] || attributes[:message]
      @location    = attributes[:location]
      @link        = attributes[:link]
      @privacy     = attributes[:privacy]
      @count       = attributes[:count]
      @type        = attributes[:type]
      
      @created_time = if attributes[:created_time]
        Time.parse(attributes[:created_time]).utc
      end
      @updated_time = if attributes[:updated_time]
        Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_comments_ = Collection.new(attributes[:comments])
    end
  end
end