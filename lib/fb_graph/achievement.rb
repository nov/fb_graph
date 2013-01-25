module FbGraph
  class Achievement < Node
    attr_accessor :type, :application, :title, :url, :description, :image, :images, :data, :updated_time, :context, :points, :display_order

    def initialize(identifier, attributes = {})
      super

      # TODO: Handle data, context in smarter way.
      [:type, :title, :url, :description, :data, :context].each do |key|
        send "#{key}=", attributes[key]
      end

      if self.data
        @points = self.data[:points]
      end

      if self.context
        @display_order = self.context[:display_order]
      end

      @images = []
      if _images_ = attributes[:image]
        _images_.each do |_image_|
          @images << _image_[:url]
        end
      end
      @image = @images.first

      if application = attributes[:application]
        application[:link] = application[:url] # for some reason, FB uses "url" only here..
        @application = Application.new(application[:id], application)
      end

      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end

    def destroy(options = {})
      options[:access_token] ||= self.access_token
      application.unregister_achievement!(url, options)
    end
  end
end