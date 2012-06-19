module FbGraph
  module Connections
    module Milestones
      def milestones(options = {})
        milestones = self.connection :milestones, options
        milestones.map! do |milestone|
          Milestone.new milestone[:id], milestone.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def milestone!(options = {})
        milestone = post options.merge(:connection => :milestones)
        Milestone.new milestone[:id], options.merge(milestone).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end
