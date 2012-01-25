module FbGraph
  module Connections
    module Pokes
      def pokes(options = {})
        pokes = self.connection :pokes, options
        pokes.map! do |poke|
          Poke.new poke
        end
      end
    end
  end
end