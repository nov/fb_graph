module FbGraph
  module Connections
    module Books
      def books(options = {})
        books = self.connection :books, options
        books.map! do |book|
          Page.new book[:id], book.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end