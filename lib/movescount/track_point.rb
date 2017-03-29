module Movescount
  class TrackPoint < OpenStruct
    attr_accessor :move
    
    def initialize(move, attributes={})
      @move = move
      super attributes
    end
  end
end
