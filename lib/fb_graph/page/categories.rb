Dir[File.dirname(__FILE__) + '/categories/*.rb'].each do |file| 
  require file
end