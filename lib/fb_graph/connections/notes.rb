module FbGraph
  module Connections
    module Notes
      def notes(options = {})
        notes = FbGraph::Collection.new(get(options.merge(:connection => 'notes')))
        notes.map! do |note|
          Note.new(note.delete(:id), note)
        end
      end

      def note!(options = {})
        note = post(options.merge(:connection => 'notes'))
        Note.new(note.delete(:id), options.merge(note))
      end
    end
  end
end