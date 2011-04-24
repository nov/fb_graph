require 'spec_helper'

describe FbGraph::Project, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id   => 184246058253896,
      :name => "Drecom Blog",
      :with => [{
        :id   => 1064067203,
        :name => "Takanori Ishikawa"
      }],
      :start_date => "2008-04",
      :end_date   => "2008-09"
    }
    project = FbGraph::Project.new(attributes.delete(:id), attributes)
    project.with.should == [FbGraph::User.new(1064067203, :name => "Takanori Ishikawa")]
    project.start_date.should == Date.new(2008, 4)
    project.end_date.should   == Date.new(2008, 9)
  end

  it 'should treat 2008-00 style date' do
    attributes = {
      :id   => 184246058253896,
      :name => "Drecom Blog",
      :start_date => "2008-00",
      :end_date   => "2009-00"
    }
    project = FbGraph::Project.new(attributes.delete(:id), attributes)
    project.start_date.should == Date.new(2008)
    project.end_date.should   == Date.new(2009)
  end

  it 'should treat 2008 style date' do
    attributes = {
      :id   => 184246058253896,
      :name => "Drecom Blog",
      :start_date => "2008",
      :end_date   => "2009"
    }
    project = FbGraph::Project.new(attributes.delete(:id), attributes)
    project.start_date.should == Date.new(2008)
    project.end_date.should   == Date.new(2009)
  end

end