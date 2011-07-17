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
    end
  end
end