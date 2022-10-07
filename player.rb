# frozen_string_literal: true

require 'io/console'

# class for human playing the game
class Player
  attr_reader :symbol, :name
  attr_accessor :choices, :score

  def initialize(name, symbol, game)
    @name = name
    @symbol = symbol
    @choices = []
    @score = 0
    @game = game
  end

  def play
    $stdin.iflush
    input = gets.chomp.to_i
    until @game.board.include?(input) && (1..9).include?(input)
      puts 'Please choose a tile 1-9 that has not been taken yet'
      input = gets.chomp.to_i
    end
    @game.board[input - 1] = @symbol
    @choices.push(input)
  end
end
