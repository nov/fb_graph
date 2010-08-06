module FbGraph
  class Connection
    include Enumerable

    attr_accessor :collection, :owner, :collection

    def initialize(owner, connection, options)
      @owner = owner
      @connection = connection
      @collection = FbGraph::Collection.new(owner.get(options.merge(:connection => connection)))
    end

    def each
      self.collection.each do
        yield
      end
    end

    def next(options = {})
      new(self.owner, self.connection, options.merge(self.collection.next))
    end

    def previous(options = {})
      new(self.owner, self.connection, options.merge(self.collection.previous))
    end
  end
end