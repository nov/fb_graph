module FbGraph
  module OpenGraph
    class Object < Node
      attr_accessor :type, :application, :url, :title, :description, :images, :image, :site_name, :updated_time
      attr_accessor :raw_attributes

      def initialize(identifier, attributes = {})
        super
        @raw_attributes = attributes
        [:type, :url, :title, :description, :site_name].each do |key|
          self.send "#{key}=", attributes[key]
        end
        if application = attributes[:application]
          @application = Application.new(application[:id], application)
        end
        @images = []
        if attributes[:image]
          attributes[:image].each do |image|
            @images << image[:url]
          end
        end
        @image = @images.first
        if attributes[:updated_time]
          @updated_time = Time.parse attributes[:updated_time]
        end
      end
    end
  end
end