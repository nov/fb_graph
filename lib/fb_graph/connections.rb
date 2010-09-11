Dir[File.dirname(__FILE__) + '/connections/*.rb'].each do |file| 
  require file
end