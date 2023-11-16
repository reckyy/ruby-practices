# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize
    scores = ARGV[0].split(',').map { |s| Shot.new(s) }
    @frames = []
    @index_of_frame10 = 18
    calc_index_of_frame10(scores)
    separate_to_frame(scores)
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
                        Shot::MAX_PINS + next_frame.shot1
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

  private

  def calc_index_of_frame10(scores)
    scores.each_with_index do |s, i|
      @index_of_frame10 -= 1 if s.pins == Shot::MAX_PINS
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

      create_frame_by_shot(s, shots)
    end
  end

  def create_frame_by_shot(shot, shots)
    if shot.pins == Shot::MAX_PINS
      add_frame(Frame.new(shot.pins, 0))
    else
      shots << shot.pins
      if shots.size == 2
        add_frame(Frame.new(shots[0], shots[1]))
        shots.clear
      end
    end
  end

  def add_frame(frame)
    @frames << frame
  end

  def deal_frame10(scores)
    tenth_frame_scores = scores[@index_of_frame10..]
    frame = Frame.new(tenth_frame_scores[0].pins, tenth_frame_scores[1].pins, shot3: tenth_frame_scores[2].pins)
    add_frame(frame)
  end
end
