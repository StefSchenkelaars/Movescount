module Movescount
  class Point < OpenStruct
    attr_accessor :move

    def initialize(move, attributes = {})
      @move = move
      super attributes
    end

    # Make sure that MeasuredAt falls back to the time of the sample
    def MeasuredAt
      super || DateTime.parse(self.LocalTime)
    end
  end
end
