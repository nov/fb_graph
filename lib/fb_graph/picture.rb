module FbGraph
  class Picture
    include Comparison

    @@attributes = [:is_silhouette, :url, :height, :width]
    attr_accessor *@@attributes

    def initialize(attributes = {})
      @@attributes.each do |key|
        self.send :"#{key}=", attributes[key]
      end
    end
  end
end