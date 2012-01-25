module FbGraph
  module Connections
    module Television
      def television(options = {})
        television = self.connection :television, options
        television.map! do |_television_|
          Page.new _television_[:id], _television_.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end