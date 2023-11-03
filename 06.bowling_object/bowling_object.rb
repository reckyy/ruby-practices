# frozen_string_literal: true

require_relative `game`

game = Game.new
game.separate_to_frame
puts game.score
