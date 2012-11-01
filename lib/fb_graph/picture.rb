module FbGraph
  class Picture
    include Comparison

    attr_accessor :is_silhouette, :url

    def initialize(attributes = {})
      @is_silhouette = attributes[:is_silhouette]
      @url = attributes[:url]
    end
  end
end