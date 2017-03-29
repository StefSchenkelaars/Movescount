module Movescount
  class Sample < OpenStruct
    attr_accessor :move

    def initialize(move, attributes={})
      @move = move
      super attributes
    end

    def LocalTime
      @local_time ||= DateTime.parse(super)
    end
  end
end
