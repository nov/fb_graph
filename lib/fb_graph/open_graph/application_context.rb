module FbGraph
  module OpenGraph
    module ApplicationContext
      def og_action(name)
        self.namespace ||= fetch(:batch_mode => false).namespace
        [namespace, name].collect(&:to_s).join(':')
      end
    end
  end
end
