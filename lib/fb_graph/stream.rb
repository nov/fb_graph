module FbGraph
  class Stream < Node
    TYPES = {
      11 => "Group created",
      12 => "Event created",
      46 => "Status update",
      56 => "Post on wall from another user",
      66 => "Note created",
      80 => "Link posted",
      128 => "Video posted",
      247 => "Photos posted",
      237 => "App story",
      257 => "Comment created",
      272 => "App story",
      285 => "Checkin to a place",
      308 => "Post in Group",
      nil => "Unknown"
    }
    ATTRS = [:post_id, :likes, :share_count, :comments, :viewer_id, :app_id, 
        :updated_time, :created_time, :filter_key, :attribution, :actor_id, :target_id,
        :message, :app_data, :action_links, :attachment, :impressions, :place, :description, :type]

    attr_accessor *ATTRS

    def initialize(identifier, attributes)
      super
      ATTRS.each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
    end

    # each stream is a Post
    def fetch(options = {})
      options[:access_token] ||= self.access_token if self.access_token
      _fetched_ = get(options)
      _fetched_[:access_token] ||= options[:access_token]
      FbGraph::Post.new(_fetched_[:id], _fetched_)
    end

    # each stream is a Post
    def self.fetch(identifier, options = {})
      FbGraph::Post.new(identifier).fetch(options)
    end

    # update should update a post, since id is a post id
    # destory should delete a post, since id is a post id
  end
end
