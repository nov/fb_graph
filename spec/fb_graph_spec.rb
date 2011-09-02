require 'spec_helper'

describe FbGraph do
  subject { FbGraph }
  after { FbGraph.debugging = false }

  its(:logger) { should be_a Logger }
  its(:debugging?) { should be_false }

  describe '.debug!' do
    before { FbGraph.debug! }
    its(:debugging?) { should be_true }
  end

  describe '.debug' do
    it 'should enable debugging within given block' do
      FbGraph.debug do
        FbGraph.debugging?.should be_true
      end
      FbGraph.debugging?.should be_false
    end

    it 'should not force disable debugging' do
      FbGraph.debug!
      FbGraph.debug do
        FbGraph.debugging?.should be_true
      end
      FbGraph.debugging?.should be_true
    end
  end
end