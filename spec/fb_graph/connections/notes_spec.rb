require 'spec_helper'

describe FbGraph::Connections::Notes, '#notes' do
  context 'when included by FbGraph::User' do
    it 'should return notes as FbGraph::Note' do
      mock_graph :get, 'matake/notes', 'users/notes/matake_private', :access_token => 'access_token' do
        notes = FbGraph::User.new('matake', :access_token => 'access_token').notes
        notes.each do |note|
          note.should be_instance_of(FbGraph::Note)
        end
      end
    end
  end
end

describe FbGraph::Connections::Notes, '#note!' do
  context 'when included by FbGraph::Page' do
    it 'should return generated note' do
      mock_graph :post, '12345/notes', 'pages/notes/post_with_valid_access_token', :params => {
        :subject => 'test',
        :message => 'hello'
      }, :access_token => 'valid' do
        note = FbGraph::Page.new('12345', :access_token => 'valid').note!(:subject => 'test', :message => 'hello')
        note.identifier.should == 396664845100
        note.subject.should == 'test'
        note.message.should == 'hello'
        note.access_token.should == 'valid'
      end
    end
  end
end