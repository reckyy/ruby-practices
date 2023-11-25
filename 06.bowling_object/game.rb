# frozen_string_literal: true

require_relative 'frame'

class Game
  MAX_INDEX_OF_FRAME10 = 18

  def initialize
    scores = ARGV[0].split(',').map { |s| Shot.new(s) }
    @index_of_frame10 = calc_index_of_frame10(scores)
    @frames = separate_to_frame(scores)
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
    index_of_frame10 = Game::MAX_INDEX_OF_FRAME10
    scores.each_with_index do |s, i|
      index_of_frame10 -= 1 if s.strike?
      break if i == index_of_frame10 - 1
    end
    index_of_frame10
  end

  def separate_to_frame(scores)
    shots = []
    frames = []
    scores.each_with_index do |s, i|
      if i == @index_of_frame10
        frames.push(deal_frame10(scores))
        break
      end

      create_frame_by_shot(s, shots, frames)
    end
    frames
  end

  def create_frame_by_shot(shot, shots, frames)
    if shot.strike?
      frames.push(Frame.new(shot.pins, 0))
    else
      shots << shot.pins
      if shots.size == 2
        frames.push(Frame.new(shots[0], shots[1]))
        shots.clear
      end
    end
  end

  def deal_frame10(scores)
    tenth_frame_scores = scores[@index_of_frame10..]
    shot3 = tenth_frame_scores[2] ? tenth_frame_scores[2].pins : 0
    Frame.new(tenth_frame_scores[0].pins, tenth_frame_scores[1].pins, shot3:)
  end
end
