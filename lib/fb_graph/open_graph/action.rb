module FbGraph
  module OpenGraph
    class Action < Node
      attr_accessor :type, :application, :from, :objects, :start_time, :end_time, :publish_time
      def initialize(identifier, attributes = {})
        super
        @type = attributes[:type]
        if (application = attributes[:application])
          @application = Application.new(application[:id], application)
        end
        if (from = attributes[:from])
          @from = User.new(from[:id], from)
        end
        if attributes[:data]
          @objects = {}
          attributes[:data].each do |key, _attributes_|
            @objects[key] = Object.new _attributes_[:id], _attributes_
          end
        end
        [:start_time, :end_time, :publish_time].each do |key|
          self.send "#{key}=", Time.parse(attributes[key]) if attributes[key]
        end

        # cached connection
        @_likes_ = Collection.new(attributes[:likes])
        @_comments_ = Collection.new(attributes[:comments])
      end
    end
  end
end