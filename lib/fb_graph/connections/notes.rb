module FbGraph
  module Connections
    module Notes
      def notes(options = {})
        notes = Collection.new(get(options.merge(:connection => 'notes')))
        notes.map! do |note|
          Note.new(note.delete(:id), note)
        end
      end
    end
  end
end