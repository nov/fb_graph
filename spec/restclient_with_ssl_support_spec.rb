require File.join(File.dirname(__FILE__), 'spec_helper')

describe RestClient do
  before do
    module RestClient
      class Request
        def self.execute(options = {})
          if options[:verify_ssl] == OpenSSL::SSL::VERIFY_PEER
            :secure
          else
            :insecure
          end
        end
      end
    end
  end

  it 'should support SSL' do
    [:get, :post, :put, :delete].each do |method|
      RestClient.send(method, 'https://example.com', {}).should == :secure
    end
  end
end