require 'spec_helper'

describe FbGraph::Question do

  describe '.new' do
    it 'should setup all supported attributes' do
      attributes = {
        :id => '12345',
        :from => {
          :id => '23456',
          :name => 'Mahmoud Khaled'
        },
        :question => 'question 1',
        :created_time => '2009-12-29T15:24:50+0000',
        :updated_time => '2010-01-02T15:37:41+0000',
        :options => {
          :data => [
            {
              :id => "34567",
              :from => {
                :name => "Mahmoud Khaled",
                :id => "23456"
              },
              :name => "option 1",
              :votes => 2,
              :created_time => "2011-11-07T19:49:51+0000"
            },
            {
              :id => "34568",
              :from => {
                :name => "Mustafa Badawy",
                :id => "23457"
              },
              :name => "option 2",
              :votes => 0,
              :created_time => "2011-11-07T19:49:48+0000"
            }
          ]
        } 
      }
      question = FbGraph::Question.new(attributes.delete(:id), attributes)
      question.identifier.should == '12345'
      question.from.should       == FbGraph::User.new('23456', :name => 'Mahmoud Khaled')
      question.question.should   == 'question 1'
      question.created_time.should == Time.parse('2009-12-29T15:24:50+0000')
      question.updated_time.should == Time.parse('2010-01-02T15:37:41+0000')
      question.question_options.should == [
        FbGraph::QuestionOption.new(
          '34567',
          :from => {
            :id => '23456',
            :name => 'Mahmoud Khaled',
          },
          :name => "option 1",
          :votes => 2,
          :created_time => "2011-11-07T19:49:51+0000"
        ),
        FbGraph::QuestionOption.new(
          '34568',
          :from => {
            :id => '23457',
            :name => 'Mustafa Badawy',
          },
          :name => "option 2",
          :votes => 0,
          :created_time => "2011-11-07T19:49:48+0000"
        )
      ]
    end

  end

end
