require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Books, '#books' do
  context 'when included by FbGraph::User' do
    before do
      fake_json(:get, 'matake/books', 'users/books/matake_public', :status => [401, 'Unauthorized'])
      fake_json(:get, 'matake/books?access_token=access_token', 'users/books/matake_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('matake').books
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return books as FbGraph::Page' do
        books = FbGraph::User.new('matake', :access_token => 'access_token').books
        books.first.should == FbGraph::Page.new(
          '102253616477130',
          :access_token => 'access_token',
          :name => 'Momo Michael Ende',
          :category => 'Unknown'
        )
        books.each do |book|
          book.should be_instance_of(FbGraph::Page)
        end
      end
    end
  end
end