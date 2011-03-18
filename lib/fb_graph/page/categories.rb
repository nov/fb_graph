Dir[File.dirname(__FILE__) + '/categories/*.rb'].each do |file| 
  require file
end

module FbGraph
  class Page
    include Categories::LocalBusiness
  end
end