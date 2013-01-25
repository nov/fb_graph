module FbGraph
  module Connections
    module Notes
      def notes(options = {})
        notes = self.connection :notes, options
        notes.map! do |note|
          Note.new note[:id], note.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def note!(options = {})
        note = post options.merge(:connection => :notes)
        Note.new note[:id], options.merge(note).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end