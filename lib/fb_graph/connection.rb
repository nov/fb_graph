module FbGraph
  class Connection < Collection
    attr_accessor :collection, :connection, :owner, :options

    def initialize(owner, connection, options = {})
      @owner = owner
      @options = options
      @connection = connection
      @collection = options[:collection] || FbGraph::Collection.new
      replace collection
    end

    def next(_options_ = {})
      if self.collection.next.present?
        self.owner.send(self.connection, self.options.merge(_options_).merge(self.collection.next))
      else
        self.class.new(self.owner, self.connection)
      end
    end

    def previous(options = {})
      if self.collection.previous.present?
        self.owner.send(self.connection, self.options.merge(_options_).merge(self.collection.previous))
      else
        self.class.new(self.owner, self.connection)
      end
    end
  end
end