# -*- coding: utf-8 -*-
require 'spec_helper'

describe FbGraph::Page do
  context 'for local_business category' do
    let :page do
      mock_graph :get, 'local_business', 'pages/categories/local_business' do
        FbGraph::Page.new('local_business').fetch
      end
    end
    subject { page }

    [
      :attire,
      :culinary_team,
      :general_manager,
      :link,
      :phone,
      :price_range,
      :public_transit
    ].each do |key|
      its(key) { should be_instance_of String }
    end

    [
      :parking,
      :payment_options,
      :restaurant_services,
      :restaurant_specialties
    ].each do |key|
      its(key) { should be_instance_of Array }
      describe key do
        it 'should be an Array of Symbol' do
          page.send(key).should_not be_blank
          page.send(key).all? do |value|
            value.should be_instance_of Symbol
          end
        end
      end
    end

    its(:hours) { should be_instance_of Hash }
    its(:hours) do
      should == {
        :mon => [{
          :open  => Time.parse('1970-01-01 10:00:00 UTC'),
          :close => Time.parse('1970-01-01 20:00:00 UTC')
        }],
        :tue=>[{
          :open  => Time.parse('1970-01-01 10:00:00 UTC'),
          :close => Time.parse('1970-01-01 20:00:00 UTC')
        }]
      }
    end

    its(:location) do
      should == FbGraph::Venue.new(
        :street => '新田辺',
        :city => 'Kyoto',
        :country => 'Japan',
        :zip => '513001'
      )
    end
  end

  context 'for local_business category with hours as Fixnums' do
    let :page do
      mock_graph :get, 'local_business', 'pages/categories/local_business_fixnum' do
        FbGraph::Page.new('local_business').fetch
      end
    end
    subject { page }

    its(:hours) { should be_instance_of Hash }
    its(:hours) do
      should == {
        :mon => [{
          :open  => Time.parse('1970-01-01 10:00:00 UTC'),
          :close => Time.parse('1970-01-01 20:00:00 UTC')
        }],
        :tue=>[{
          :open  => Time.parse('1970-01-01 10:00:00 UTC'),
          :close => Time.parse('1970-01-01 20:00:00 UTC')
        }]
      }
    end
  end
end
