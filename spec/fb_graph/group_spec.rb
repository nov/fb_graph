require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Group, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :owner => {
        :id => '23456',
        :name => 'nov matake'
      },
      :name => 'group 1',
      :description => 'a group for fb_graph test',
      :link => 'http://www.facebook.com/group/12345',
      :venue => {
        :street => 'Sakuragaoka',
        :city => 'Shibuya',
        :state => 'Tokyo',
        :zip => '150-0031',
        :country => 'Japan',
        :latitude => '35.685',
        :longitude => '139.751'
      },
      :privacy => 'OPEN',
      :updated_time => '2010-01-02T15:37:41+0000'
    }
    group = FbGraph::Group.new(attributes.delete(:id), attributes)
    group.identifier.should   == '12345'
    group.owner.should        == FbGraph::User.new('23456', :name => 'nov matake')
    group.name.should         == 'group 1'
    group.description.should  == 'a group for fb_graph test'
    group.link.should         == 'http://www.facebook.com/group/12345'
    group.venue.should        == FbGraph::Venue.new(
      :street => 'Sakuragaoka',
      :city => 'Shibuya',
      :state => 'Tokyo',
      :zip => '150-0031',
      :country => 'Japan',
      :latitude => '35.685',
      :longitude => '139.751'
    )
    group.privacy.should      == 'OPEN'
    group.updated_time.should == Time.parse('2010-01-02T15:37:41+0000')
  end

end