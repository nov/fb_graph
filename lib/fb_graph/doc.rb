module FbGraph
  class Doc < Node
    attr_accessor :from, :subject, :icon, :updated_time, :revision

    def initialize(identifier, attributes = {})
      super
      @from = if attributes[:from]
        User.new(attributes[:from][:id], attributes[:from])
      end
      @subject = attributes[:subject]
      @icon = attributes[:icon]
      @revision = attributes[:revision]
      @updated_time = if attributes[:updated_time]
        Time.parse(attributes[:updated_time]).utc
      end
    end
  end
end