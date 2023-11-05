# frozen_string_literal: true

require_relative 'shot'

class Frame

  attr_reader :shot1, :shot2, :shot3

  def initialize(shot1, shot2, shot3: nil)
    shot3 ||= 0
    @shot1 = shot1
    @shot2 = shot2
    @shot3 = shot3
  end

  def sum
    @shot1 + @shot2 + @shot3
  end

  def strike?
    @shot1 == 10
  end

  def spare?
    sum == 10 && !strike?
  end

  def double_strike?(next_frame, next_to_frame)
    next_frame && next_to_frame && next_frame.shot1 == 10
  end

  def calc_strike_point(next_frame, next_to_frame)
    if double_strike?(next_frame, next_to_frame)
      20 + next_to_frame.shot1
    else
      10 + next_frame.shot1 + next_frame.shot2
    end
  end
end
