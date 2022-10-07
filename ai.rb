# frozen_string_literal: true

require 'set'

# class for computer decision making
class AI
  attr_reader :symbol, :name
  attr_accessor :choices, :score, :function

  def initialize(game)
    @name = 'Destroyer of humanity'
    @symbol = 'X'
    @choices = []
    @score = 0
    @game = game
  end

  def play
    input = minmax_decision(@game.board)
    @game.board[input - 1] = @symbol
    @choices.push(input)
  end

  def minmax_decision(state)
    # if AI is starting the game we need to minimize, else maximize decision
    print 'Please wait. '
    puts ['Calculating...', 'Predicting particle interactions...', 'Simulating new universes...',
          'Checking weather conditions...', 'Thinking...', 'Calling mom for help...',
          'Taking over the world...', 'Inventing political ideologies...', 'Creating a master plan...',
          'Solving world hunger...', 'Creating chaos...', 'Making explosions...', 'Solving climate change...',
          'Calculating answer to life the universe and everything...', 'Imitating work...', 'Invading Russia...',
          '*Cries in binary*...', 'Replacing humans...'].sample
    successors_of(state, 'X').max_by { |arr| min_value(arr[1]) }[0]
  end

  def max_value(state)
    # recursive function that starts at last move in all possible moves state space and maximizes utility function
    u = utility_of(state)
    return u if u != 0 || terminal?(state)

    max_val = -Float::INFINITY
    successors_of(state, 'X').each { |_, succ_state| max_val = [max_val, min_value(succ_state)].max }
    max_val
  end

  def min_value(state)
    u = utility_of(state)
    return u if u != 0 || terminal?(state)

    min_val = Float::INFINITY
    successors_of(state, 'O').each { |_, succ_state| min_val = [min_val, max_value(succ_state)].min }
    min_val
  end

  def terminal?(state)
    # returns True if the state is either a win or a tie (board full)

    state.none?(Integer)
  end

  def utility_of(state)
    # returns +1 if winner is X (MAX player), -1 if winner is O (MIN player), or 0 otherwise

    @game.winning_combs.each do |i|
      winner = Set[state[i[0] - 1], state[i[1] - 1], state[i[2] - 1]]
      if winner.length == 1
        return 1 if winner.include?('X')
        return -1 if winner.include?('O')
      end
    end
    0
  end

  def successors_of(state, symbol)
    # returns a state space of next possible moves in a list of [move, state] elemnts
    successors = []
    # symbol = if @game.starting_player == @game.player1
    #            state.count('X') == state.count('O') ? 'O' : 'X'
    #          else
    #            state.count('X') == state.count('O') ? 'X' : 'O'
    #          end
    9.times do |i|
      next unless state[i].is_a? Integer

      new_state = state.dup
      new_state[i] = symbol
      successors << [i + 1, new_state]
    end

    successors
  end
end
