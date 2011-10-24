module FbGraph
  module OpenGraph
    module ApplicationContext
      def og_action(name)
        fetch unless namespace
        [namespace, name].collect(&:to_s).join(':')
      end
    end
  end
end