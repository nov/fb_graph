Dir[File.dirname(__FILE__) + '/request_filters/*.rb'].each do |file|
  require file
end