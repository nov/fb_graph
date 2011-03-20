require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Page::CategoryAttributes do
  before do
    fake_json(:get, 'local_business', 'pages/categories/local_business')
  end
  let(:page) { FbGraph::Page.new('local_business').fetch }
  subject { page }

  [:attire, :culinary_team, :general_manager, :phone, :price_range, :public_transit].each do |key|
    its(key) { should be_instance_of String }
  end

  [:parking, :payment_options, :restaurant_services, :restaurant_specialties].each do |key|
    its(key) { should be_instance_of Array }
    describe key do
      it 'should be an Array of Symbol' do
        page.send(key).all? do |value|
          value.should be_instance_of Symbol
        end
      end
    end
  end

  its(:hours) { should be_instance_of Hash }
  its(:hours) do
    should == {
      :mon => [
        {:open  => Time.parse('Thu Jan 01 09:00:00 UTC 1970')},
        {:close => Time.parse('Thu Jan 01 17:00:00 UTC 1970')}
      ]
    }
  end
end