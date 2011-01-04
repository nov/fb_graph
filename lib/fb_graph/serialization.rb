module FbGraph
  module Serialization
    def to_hash(options = {})
      raise "Define #{self.class}#to_hash!"
    end

    def as_json(options = {})
      hash = self.to_hash options
      hash.delete_if do |k, v|
        v.blank?
      end
      hash
    end

    def to_json(options = {})
      as_json.to_json options
    end
  end
end