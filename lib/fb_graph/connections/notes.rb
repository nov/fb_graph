module FbGraph
  module Connections
    module Notes
      def notes(options = {})
        notes = FbGraph::Collection.new(get(options.merge(:connection => 'notes')))
        notes.map! do |note|
          Note.new(note.delete(:id), note.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def note!(options = {})
        note = post(options.merge(:connection => 'notes'))
        Note.new(note.delete(:id), options.merge(note).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end