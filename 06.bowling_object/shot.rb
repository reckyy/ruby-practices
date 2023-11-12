# frozen_string_literal: true

MAX_PINS = 10

class Shot
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def pins
    @symbol == 'X' ? MAX_PINS : @symbol.to_i
  end
end
