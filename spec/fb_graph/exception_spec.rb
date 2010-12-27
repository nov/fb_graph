require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Exception do
  context 'when response body is given' do
    it 'should setup message and type from error' do
      err = FbGraph::Exception.new(400, 'This is the original message', {
        :error => {
          :type => 'SomeError',
          :message => 'This is the error message'
        }
      }.to_json)
      err.code.should == 400
      err.type.should == 'SomeError'
      err.message.should == 'This is the error message'
    end
  end

  context 'when response body is not given' do
    it 'should not have type' do
      err = FbGraph::Exception.new(400, 'This is the original message')
      err.code.should == 400
      err.type.should be_nil
      err.message.should == 'This is the original message'
    end
  end
end

describe FbGraph::BadRequest do
  it 'should have 400 status code' do
    err = FbGraph::BadRequest.new 'Bad Request'
    err.code.should == 400
  end
end

describe FbGraph::Unauthorized do
  it 'should have 401 status code' do
    err = FbGraph::Unauthorized.new 'Unauthorized'
    err.code.should == 401
  end
end

describe FbGraph::NotFound do
  it 'should have 404 status code' do
    err = FbGraph::NotFound.new 'Not Found'
    err.code.should == 404
  end
end