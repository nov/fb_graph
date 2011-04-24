require 'spec_helper'

describe FbGraph::Work, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :employer => {
        :id => 107722015925937,
        :name => "Drecom Co., Ltd."
      },
      :location => {
        :id => 111736052177472,
        :name => "Tokyo, Tokyo"
      },
      :position => {
        :id => 111091815582753,
        :name => "Web Engineer"
      },
      :projects => [{
        :id   => 184246058253896,
        :name => "Drecom Blog",
        :with => [{
          :id   => 1064067203,
          :name => "Takanori Ishikawa"
        }],
        :start_date => "2008-04",
        :end_date   => "2008-09"
      }],
      :start_date => "2007-04",
      :end_date   => "2008-09"
    }
    work = FbGraph::Work.new(attributes)
    work.employer.should == FbGraph::Page.new(
      107722015925937,
      :name => "Drecom Co., Ltd."
    )
    work.location.should == FbGraph::Page.new(
      111736052177472,
      :name => "Tokyo, Tokyo"
    )
    work.position.should == FbGraph::Page.new(
      111091815582753,
      :name => "Web Engineer"
    )
    work.projects.should == [FbGraph::Project.new(
      184246058253896,
      :name => "Drecom Blog",
      :with => [{
        :id   => 1064067203,
        :name => "Takanori Ishikawa"
      }],
      :start_date => "2008-04",
      :end_date   => "2008-09"
    )]
    work.start_date.should == Date.new(2007, 4)
    work.end_date.should   == Date.new(2008, 9)
  end

  it 'should ignore 0000-00 style date' do
    attributes = {
      :employer => {
        :id => 105612642807396,
        :name => "Cerego Japan Inc."
      },
      :start_date => "0000-00",
      :end_date   => "0000-00"
    }
    work = FbGraph::Work.new(attributes)
    work.start_date.should be_nil
    work.end_date.should be_nil
  end

  it 'should treat 2010-00 date ' do
    attributes = {
      :employer => {
        :id => 105612642807396,
        :name => "Cerego Japan Inc."
      },
      :start_date => "2008-00",
      :end_date   => "2010-00"
    }
    work = FbGraph::Work.new(attributes)
    work.start_date.should == Date.new(2008, 1)
    work.end_date.should ==  Date.new(2010, 1)
  end

  it 'should treat 2010 date ' do
    attributes = {
      :employer => {
        :id => 105612642807396,
        :name => "Cerego Japan Inc."
      },
      :start_date => "2008",
      :end_date   => "2010"
    }
    work = FbGraph::Work.new(attributes)
    work.start_date.should == Date.new(2008)
    work.end_date.should ==  Date.new(2010)
  end

end