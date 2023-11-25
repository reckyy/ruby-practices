# frozen_string_literal: true

class Shot
  MAX_PINS = 10
  STRIKE_SYMBOL = 'X'

  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def pins
    @symbol == STRIKE_SYMBOL ? MAX_PINS : @symbol.to_i
  end

  def strike?
    @symbol == STRIKE_SYMBOL
  end
end
