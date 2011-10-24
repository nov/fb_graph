module FbGraph
  module OpenGraph
    class Object < Node
      attr_accessor :type, :application, :url, :title, :description, :locale, :site_name, :updated_time
      attr_accessor :images, :image, :audios, :audio, :videos, :video
    end
  end
end