require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Application, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id          => '12345',
      :name        => 'FbGraph',
      :description => 'Owsome Facebook Graph Wrapper',
      :category    => 'Programming',
      :subcategory => 'Open Source',
      :link        => 'http://github.com/nov/fb_graph',
      :secret      => 'sec sec'
    }
    app = FbGraph::Application.new(attributes.delete(:id), attributes)
    app.identifier.should  == '12345'
    app.name.should        == 'FbGraph'
    app.description.should == 'Owsome Facebook Graph Wrapper'
    app.category.should    == 'Programming'
    app.subcategory.should == 'Open Source'
    app.link.should        == 'http://github.com/nov/fb_graph'
    app.secret.should      == 'sec sec'
  end

end