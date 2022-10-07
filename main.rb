# frozen_string_literal: true

require_relative 'player'
require_relative 'ai'
require_relative 'game'

game = Game.new
loop do
  game.start
  break unless game.rematch?

  game.play_again
end
