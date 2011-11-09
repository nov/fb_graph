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

            def #{setting}!(options = {})
              enable! :#{setting}, options
            end

            def #{setting.to_s.sub('can', 'cannot')}!(options = {})
              disable! :#{setting}, options
            end
          SETTING
        end
      end

      def settings(options = {})
        @settings = nil if options[:no_cache]
        @settings ||= self.connection(:settings, options).inject([]) do |_settings_, _setting_|
          _settings_ << _setting_[:setting].downcase.to_sym if _setting_[:value]
          _settings_
        end
      end

      def enable!(setting, options = {})
        __update_setting__ setting, true, options
      end

      def disable!(setting, options = {})
        __update_setting__ setting, false, options
      end

      private

      def __update_setting__(setting, value, options = {})
        succeeded = post options.merge(
          :setting => setting.to_s.upcase,
          :value => value,
          :connection => :settings
        )
        if succeeded
          @settings ||= []
          if value
            @settings << setting.to_sym
          else
            @settings.delete_if { |key| key == setting.to_sym }
          end
        end
        succeeded
      end
    end
  end
end