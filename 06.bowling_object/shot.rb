# frozen_string_literal: true

MAX_PINS = 10
STRIKE_SYMBOL = 'X'

class Shot
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def pins
    @symbol == STRIKE_SYMBOL ? MAX_PINS : @symbol.to_i
  end
end
