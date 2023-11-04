# frozen_string_literal: true

class Shot
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def pins
    @symbol == 'X' ? 10 : @symbol.to_i
  end
end
