module FbGraph
  module Connections
    module Tabs
      def tabs(options = {})
        tabs = self.connection(:tabs, options)
        tabs.map! do |tab|
          Tab.new(tab[:id], tab.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def tab!(options = {})
        post options.merge(:connection => :tabs)
      end
    end
  end
end