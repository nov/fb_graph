module FbGraph
  class AdCreative < Node

    ATTRS = [:id, :view_tag, :alt_view_tags, :creative_id, :type, :title, :body, :image_hash, :link_url, :name, :run_status, :preview_url, :count_current_adgroups, :image_url] 

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
    end
  end
end

