# frozen_string_literal: true

class Game

  def initialize
    @frames = []
  end

  def add_frame(frame)
    @frames << frame
  end

  def score
    game_score = 0
    0.upto(9) do |i|
      next_frame = @frames[i + 1]
      next_to_frame = @frames[i + 2]
      if i < 9
        score = if @frames[0].shot1 == 10 # strike
                  @frames[i].calc_strike_point(next_frame, next_to_frame)
                elsif frame.sum == 10 # spare
                  10 + next_frame[0]
                else
                  @frames[i].sum
                end
      else
        game_score += @frames[i].sum
        break
      end
      game_score += score
    end
    game_score
  end

  def separate_to_frame
    scores = ARGV[0].split(',')
    shots = []
    scores.each_with_index do |s, i|
    break if i == 9

    shot = Shot.new(s)
    if shot.pins == 'X'
      frame = Frame.new(10, 0)
      add_frame(frame)
    else
      shots << shot.pins
      if shots.size == 2
        frame = Frame.new(shots[0], shots[1])
        shots.clear
      end
    end
      add_frame(frame)
    end
    add_frame(scores[18..])
  end
end
