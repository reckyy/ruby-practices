# frozen_string_literal: true

class Shot
  def initialize(symbol)
    @symbol = symbol
  end

  def pins
    @symbol == 'X' ? 10 : @symbol.to_i
  end
end
