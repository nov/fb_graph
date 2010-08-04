require File.join(File.dirname(__FILE__), '../../spec_helper')

context 'when included by FbGraph::User' do
  describe FbGraph::Connections::Notes, '#notes' do
    before(:all) do
      fake_json(:get, 'matake/notes?access_token=access_token', 'users/notes/matake_private')
    end

    it 'should return notes as FbGraph::Note' do
      notes = FbGraph::User.new('matake', :access_token => 'access_token').notes
      notes.each do |note|
        note.should be_instance_of(FbGraph::Note)
      end
    end
  end
end

context 'when included by FbGraph::Page' do
  describe FbGraph::Connections::Notes, '#note!' do
    before do
      fake_json(:post, '12345/notes', 'pages/notes/post_with_valid_access_token')
    end

    it 'should return generated note' do
      note = FbGraph::Page.new('12345', :access_token => 'valid').note!(:subject => 'test', :message => 'hello')
      note.identifier.should == 396664845100
      note.subject.should == 'test'
      note.message.should == 'hello'
      note.access_token.should == 'valid'
    end
  end
end