# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize
    scores = ARGV[0].split(',')
    @frames = []
    @index_of_frame10 = 18
    calc_index_of_frame10(scores)
    separate_to_frame(scores)
  end

  def calc_index_of_frame10(scores)
    scores.each_with_index do |s, i|
      @index_of_frame10 -= 1 if s == STRIKE_SYMBOL
      break if i == @index_of_frame10 - 1
    end
  end

  def separate_to_frame(scores)
    shots = []
    scores.each_with_index do |s, i|
      if i == @index_of_frame10
        deal_frame10(scores)
        break
      end

      shot = Shot.new(s)
      create_frame_by_shot(shot, shots)
    end
  end

  def create_frame_by_shot(shot, shots)
    if shot.symbol == STRIKE_SYMBOL
      frame = Frame.new(MAX_PINS, 0)
      add_frame(frame)
    else
      shots << shot.pins
      if shots.size == 2
        frame = Frame.new(shots[0], shots[1])
        add_frame(frame)
        shots.clear
      end
    end
  end

  def add_frame(frame)
    @frames << frame
  end

  def deal_frame10(scores)
    tenth_frame_scores = scores[@index_of_frame10..].map { |s| Shot.new(s).pins }
    frame = Frame.new(tenth_frame_scores[0], tenth_frame_scores[1], shot3: tenth_frame_scores[2])
    add_frame(frame)
  end

  def calc_score
    game_score = 0
    0.upto(9) do |i|
      next_frame = @frames[i + 1]
      next_to_frame = @frames[i + 2]
      if i < 9
        frame_score = if @frames[i].strike?
                        @frames[i].calc_strike_point(next_frame, next_to_frame)
                      elsif @frames[i].spare?
                        MAX_PINS + next_frame.shot1
                      else
                        @frames[i].score
                      end
      else
        game_score += @frames[i].score
        break
      end
      game_score += frame_score
    end
    game_score
  end
end
