# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shot1, :shot2, :shot3

  def initialize(shot1, shot2, shot3: nil)
    @shot1 = shot1
    @shot2 = shot2
    @shot3 = shot3 || 0
  end

  def sum
    @shot1 + @shot2 + @shot3
  end

  def strike?
    @shot1 == MAX_PINS
  end

  def spare?
    sum == MAX_PINS && !strike?
  end

  def double_strike?(next_frame, next_to_frame)
    next_frame && next_to_frame && next_frame.shot1 == MAX_PINS
  end

  def calc_strike_point(next_frame, next_to_frame)
    if double_strike?(next_frame, next_to_frame)
      (MAX_PINS * 2) + next_to_frame.shot1
    else
      MAX_PINS + next_frame.shot1 + next_frame.shot2
    end
  end
end
