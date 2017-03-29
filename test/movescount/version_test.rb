require 'test_helper'

describe Movescount do
  describe 'VERSION' do
    it 'has a version number' do
      Movescount::VERSION.must_be_instance_of String
    end
  end
end
