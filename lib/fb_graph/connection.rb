module FbGraph
  class Connection < Collection
    attr_accessor :collection, :connection, :owner

    def initialize(owner, connection, collection = FbGraph::Collection.new)
      @owner = owner
      @connection = connection
      @collection = collection
      replace collection
    end

    def next(options = {})
      if self.collection.next.present?
        self.owner.send(self.connection, options.merge(self.collection.next))
      else
        self.class.new(self.owner, self.connection)
      end
    end

    def previous(options = {})
      if self.collection.previous.present?
        self.owner.send(self.connection, options.merge(self.collection.previous))
      else
        self.class.new(self.owner, self.connection)
      end
    end
  end
end