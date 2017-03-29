module Movescount
  class Configuration
    attr_accessor :app_key, :api_uri

    def initialize
      @api_uri = 'https://uiservices.movescount.com'
      return
    end
  end
end
