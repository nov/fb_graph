module FbGraph
  class Place < Page
    def to_json(options = {})
      self.identifier
    end
  end
end