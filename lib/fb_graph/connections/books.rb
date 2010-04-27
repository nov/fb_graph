module FbGraph
  module Connections
    module Books
      def books(options = {})
        books = FbGraph::Collection.new(get(options.merge(:connection => 'books')))
        books.map! do |book|
          Page.new(book.delete(:id), book)
        end
      end
    end
  end
end