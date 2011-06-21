require 'spec_helper'

describe FbGraph::Doc do
  describe '.new' do
    let :attributes do
      {
        :id => '12345',
        :from => {
          :id => '123456',
          :name => 'Nov Matake'
        },
        :subject => 'Subject',
        :icon => 'https://s-static.ak.facebook.com/rsrc.php/v1/yi/r/-64q65AWgXb.png',
        :updated_time => '2011-03-12T02:43:04+0000',
        :revision => 207279219287628
      }
    end
    it 'should setup all supported attributes' do
      doc = FbGraph::Doc.new(attributes[:id], attributes)
      doc.identifier.should == '12345'
      doc.from.should == FbGraph::User.new('123456', :name => 'Nov Matake')
      doc.subject.should == 'Subject'
      doc.icon.should == 'https://s-static.ak.facebook.com/rsrc.php/v1/yi/r/-64q65AWgXb.png'
      doc.revision.should == 207279219287628
    end
  end
end