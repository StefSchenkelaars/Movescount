require 'test_helper'

describe Movescount do
  describe '.configuration' do
    it 'creates a configuration' do
      Movescount.configuration.must_be_instance_of Movescount::Configuration
    end
    it 'caches the configuration' do
      Movescount.configuration.must_equal Movescount.configuration
    end
  end

  describe '.configure' do
    it 'allows a block that sets configs' do
      new_key = 'abcdefghijklmno'
      Movescount.configure{|c| c.app_key = new_key }
      Movescount.configuration.app_key.must_equal new_key
      # Make sure the test suite is clean again
      Movescount.remove_class_variable(:@@configuration)
    end
  end
end
