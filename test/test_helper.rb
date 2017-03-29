$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'movescount'

# Dependencies
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'

#VCR config
VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/cassettes'
  c.hook_into :webmock
end

# Set the default test app_key before each test
class MiniTest::Spec
  before do
    Movescount.configure do |config|
      config.app_key = 'TestAppKey'
    end
  end
end
