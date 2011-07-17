module FbGraph
  module Connections
    module Settings
      AVAILABLE_SETTINGS = [
        :users_can_post,
        :users_can_post_photos,
        :users_can_tag_photos,
        :users_can_post_videos
      ]

      def self.included(klass)
        AVAILABLE_SETTINGS.each do |setting|
          klass.class_eval <<-SETTING
            def #{setting}?(options = {})
              settings(options).include? :#{setting}
            end
          SETTING
        end
      end

      def settings(options = {})
        @settings = nil if options[:no_cache]
        @settings ||= self.connection(:settings, options).inject([]) do |settings, setting|
          settings << setting[:setting].downcase.to_sym if setting[:value]
          settings
        end
      end

      def setting!(options = {})
        options.keys.each do |key|
          if AVAILABLE_SETTINGS.include?(key.to_sym)
            options[key.to_s.uppercase] = options.delete(key)
          end
        end
        post _options_.merge(:connection => :settings)
      end
    end
  end
end