require 'httparty'
Dir[File.dirname(__FILE__) + '/movescount/**/*.rb'].each{ |f| require f }

module Movescount

  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  module Concern; end

end
