module FbGraph
  class AdConnectionObject < Node
    attr_accessor :name, :url, :type, :tabs, :picture, :object

    TYPES = {
      :page => 1,
      :application => 2,
      :event => 3,
      :place => 6,
      :domain => 7
    }

    def initialize(identifier, attributes = {})
      super

      %w(name url type tabs picture).each do |field|
        send("#{field}=", attributes[field.to_sym])
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
