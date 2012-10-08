module FbGraph
  class AdCreative < Node

    ATTRS = [
      :id,
      :view_tag,
      :alt_view_tags,
      :creative_id,
      :type,
      :title,
      :body,
      :image_hash,
      :link_url,
      :name,
      :run_status,
      :preview_url,
      :count_current_adgroups,
      :facebook_object_id, # can't use object_id since it's a core ruby method
      :story_id,
      :image_url,
      :url_tags,
      :related_fan_page,
      :auto_update,
      :action_spec,
      :query_templates
    ]

    attr_accessor *ATTRS 
    def initialize(identifier, attributes = {})
      super
      set_attrs(attributes)
    end

    protected

    def set_attrs(attributes)
      ATTRS.each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
      self.facebook_object_id = attributes[:object_id]
    end
  end
end

