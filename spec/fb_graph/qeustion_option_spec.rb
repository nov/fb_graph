require 'spec_helper'

describe FbGraph::QuestionOption do

  describe '.new' do
    it 'should setup all supported attributes' do
      attributes = {
        :id => '12345',
        :from => {
          :id => '23456',
          :name => 'Mahmoud Khaled'
        },
        :name => 'option 1',
        :votes => 5,
        :object => {:name => "Ruby programming language",
          :category => "Interest",
          :id => "109932262369283"
        },
        :created_time => '2009-12-29T15:24:50+0000'
      }
      question = FbGraph::QuestionOption.new(attributes.delete(:id), attributes)
      question.identifier.should        == '12345'
      question.from.should              == FbGraph::User.new('23456', :name => 'Mahmoud Khaled')
      question.name.should              == 'option 1'
      question.vote_count.should        == 5
      question.object.should            be_instance_of(FbGraph::Page)
      question.object.name.should       == "Ruby programming language"
      question.object.category.should   == "Interest"
      question.object.identifier.should == "109932262369283"
      question.created_time.should      == Time.parse('2009-12-29T15:24:50+0000')
    end

  end

end
