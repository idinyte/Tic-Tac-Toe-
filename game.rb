# frozen_string_literal: true

require 'active_support/inflector' # for pluralize function


# contains game logic
class Game
  attr_reader :starting_player, :player1, :player2, :winning_combs
  attr_accessor :board

  def initialize
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @winning_combs = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
                      [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    select_players
    @starting_player = player1
    @turn = @starting_player
  end

  def select_players
    puts 'press (1) to play against AI'
    puts 'press (2) to play against human'
    input = gets.chomp.to_i
    until [1, 2].include?(input)
      puts 'type 1 or 2'
      input = gets.chomp.to_i
    end
    @player1 = Player.new('Player 1', 'O', self)
    @player2 = input == 1 ? AI.new(self) : Player.new('Player 2', 'X', self)
  end

  def start
    @turn = @turn == @player2 ? @player1 : @player2
    until game_over?
      @turn = @turn == @player2 ? @player1 : @player2
      clear_screen
      display_board
      puts "#{@turn.name} turn (#{@turn.symbol})"
      @turn.play
    end
    @turn.score += 1 unless tie?
    display_results
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def display_board
    puts ['                ',
          "  #{@board[6]}  |  #{@board[7]}  |  #{@board[8]} ",
          '  ――――――――――――――',
          "  #{@board[3]}  |  #{@board[4]}  |  #{@board[5]} ",
          '  ――――――――――――――',
          "  #{@board[0]}  |  #{@board[1]}  |  #{@board[2]} ",
          '                ']
  end

  def play_again
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @player1.choices = []
    @player2.choices = []
    @starting_player = @starting_player == @player1 ? @player2 : @player1
    @turn = @starting_player
  end

  def game_over?
    winner? || tie?
  end

  def tie?
    @board.none?(Integer)
  end

  def winner?
    @winning_combs.any? { |comb| comb - @turn.choices == [] }
  end

  def draw_winning_line
    @winning_combs.each do |comb|
      if comb - @turn.choices == []
        comb.each { |c| board[c - 1] = '⭐' }
        break
      end
    end
  end

  def display_results
    clear_screen
    if tie?
      display_board
      puts "tie\n\n"
    else
      draw_winning_line
      display_board
      puts "#{@turn.name} has won!\n\n"
    end
    puts "#{@player1.name} has #{@player1.score} #{'win'.pluralize(@player1.score)}"
    puts "#{@player2.name} has #{@player2.score} #{'win'.pluralize(@player2.score)}"
  end

  def rematch?
    puts "\nPlay again? (y/n)"
    input = gets.chomp.downcase
    choices = %w[yes y]
    choices.include?(input)
  end
end
