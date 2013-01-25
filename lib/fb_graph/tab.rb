module FbGraph
  class Tab < Node
    attr_accessor :link, :application, :custom_name, :is_permanent, :position, :is_non_connection_landing_tab

    def initialize(identifier, attributes = {})
      super
      @link = attributes[:link]
      @application = if attributes[:application]
        Application.new(attributes[:application][:id], attributes[:application])
      end
      @custom_name = attributes[:custom_name]
      @is_permanent = attributes[:is_permanent]
      @position = attributes[:position]
      @is_non_connection_landing_tab = attributes[:is_non_connection_landing_tab]
    end
  end
end