if RUBY_VERSION >= '1.9'
  require 'cover_me'
  at_exit do
    CoverMe.complete!
  end
end

require 'fb_graph'
require 'rspec'
require 'helpers/webmock_helper'