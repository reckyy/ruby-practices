# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize
    @frames = []
  end

  def add_frame(frame)
    @frames << frame
  end

  def calc_frame9_of_number(scores, frame9_of_number: 18)
    scores.each_with_index do |s, i|
      frame9_of_number -= 1 if s == 'X'
      break if i == frame9_of_number - 1
    end
    frame9_of_number
  end

  def deal_frame10(scores, initial_number_of_frame10)
    tenth_frame_scores = scores[initial_number_of_frame10..].map { |s| Shot.new(s).pins }
    frame = Frame.new(tenth_frame_scores[0], tenth_frame_scores[1], shot3: tenth_frame_scores[2])
    add_frame(frame)
  end

  def create_frame_by_shot(shot, shots)
    if shot.symbol == 'X'
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

  def separate_to_frame
    scores = ARGV[0].split(',')
    shots = []
    initial_number_of_frame10 = calc_frame9_of_number(scores)
    scores.each_with_index do |s, i|
      if i == initial_number_of_frame10
        deal_frame10(scores, initial_number_of_frame10)
        break
      end

      shot = Shot.new(s)
      create_frame_by_shot(shot, shots)
    end
  end

  def calc_score
    game_score = 0
    0.upto(9) do |i|
      next_frame = @frames[i + 1]
      next_to_frame = @frames[i + 2]
      if i < 9
        frame_score = if @frames[i].shot1 == MAX_PINS # strike
                        @frames[i].calc_strike_point(next_frame, next_to_frame)
                      elsif @frames[i].sum == MAX_PINS # spare
                        MAX_PINS + next_frame.shot1
                      else
                        @frames[i].sum
                      end
      else
        game_score += @frames[i].sum
        break
      end
      game_score += frame_score
    end
    game_score
  end
end
