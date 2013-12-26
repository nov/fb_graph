require 'spec_helper'

describe FbGraph::RequestFilters::Scrubber do
  describe '#filter_response' do
    let(:original_body) { "{ \"name\": \"John\x80\" }".force_encoding('UTF-8') }
    let(:resource_endpoint) { 'https://graph.facebook.com/matake' }
    let(:request) { HTTP::Message.new_request(:get, URI.parse(resource_endpoint)) }
    let(:response) { HTTP::Message.new_response(original_body) }
    let(:request_filter) { FbGraph::RequestFilters::Scrubber.new }

    if 'string'.respond_to?(:scrub!)
      it 'should scrub response body' do
        request_filter.filter_response(request, response)
        response.body.should eq "{ \"name\": \"John\uFFFD\" }"
      end
    else
      it 'should not do anything' do
        request_filter.filter_response(request, response)
        response.body.should eq original_body
      end
    end
  end
end