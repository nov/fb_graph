module FbGraph
  class BatchResponse < Array
    def completed
      self.select { |item| item.kind_of? FbGraph::Node }
    end
    def failed
      self.select { |item| item.kind_of? FbGraph::Exception }
    end
  end
end
