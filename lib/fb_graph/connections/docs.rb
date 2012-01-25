module FbGraph
  module Connections
    module Docs
      def docs(options = {})
        docs = self.connection :docs, options
        docs.map! do |doc|
          Doc.new doc[:id], doc.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end