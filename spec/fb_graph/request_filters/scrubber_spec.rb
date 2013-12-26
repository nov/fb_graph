require 'spec_helper'

describe FbGraph::RequestFilters::Scrubber do
  let(:resource_endpoint) { 'https://graph.facebook.com/matake' }
  let(:request) { HTTP::Message.new_request(:get, URI.parse(resource_endpoint)) }
  let(:response) { HTTP::Message.new_response("{ \"name\": \"John\x80\" }".force_encoding('UTF-8')) }
  let(:request_filter) { FbGraph::RequestFilters::Scrubber.new }

  describe '#filter_response' do
    it 'should log response' do
      request_filter.filter_response(request, response)
      response.body.should eq "{ \"name\": \"John\uFFFD\" }"
    end
  end
end
