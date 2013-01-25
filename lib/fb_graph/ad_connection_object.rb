module FbGraph
  class AdConnectionObject < Node
    attr_accessor :name, :url, :type, :tabs, :picture, :object, :is_game, :og_actions, :og_namespace, :og_objects, :supported_platforms

    TYPES = {
      :page => 1,
      :application => 2,
      :event => 3,
      :place => 6,
      :domain => 7
    }
    
    SUPPORTED_PLATFORM_TYPES = {
      :web => 1,
      :canvas => 2,
      :mobile_web => 3,
      :iphone => 4,
      :ipad => 5,
      :android => 6
    }
    
    def initialize(identifier, attributes = {})
      super

      %w(name url type tabs picture).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
      
      if self.type == TYPES[:application]
        %w(is_game og_actions og_namespace og_objects supported_platforms).each do |field|
          send("#{field}=", attributes[field.to_sym])
        end
      end

      self.object = if page?
        FbGraph::Page.new(identifier)
      elsif application?
        FbGraph::Application.new(identifier)
      elsif event?
        FbGraph::Event.new(identifier)
      elsif place?
        FbGraph::Place.new(identifier)
      elsif domain?
        FbGraph::Domain.new(identifier)
      end
    end

    # Defines methods for page?, application?, event? and so forth
    TYPES.keys.each do |object_type|
      define_method("#{object_type}?") { type == TYPES[object_type] }
    end
  end
end