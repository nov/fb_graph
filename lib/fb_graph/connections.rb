Dir[File.dirname(__FILE__) + '/connections/*.rb'].each do |file| 
  require file
end

module FbGraph
  module Connections
    attr_accessor :connection
    
  end
end