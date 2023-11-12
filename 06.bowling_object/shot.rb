# frozen_string_literal: true

class Shot
  attr_reader :symbol

  MAX_PINS = 10

  def initialize(symbol)
    @symbol = symbol
  end

  def pins
    @symbol == 'X' ? MAX_PINS : @symbol.to_i
  end
end
