class Player
  attr_reader :symbol, :name
  attr_accessor :choices, :score
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @choices = []
    @score = 0
  end
end

player1 = Player.new("Player 1", "X")
player2 = Player.new("Player 2", "O")
board_arr = [1,2,3,4,5,6,7,8,9]


def play(player, board_arr)
  input = gets.chomp.to_i
  until board_arr.include?(input) && input != "X" && input != "O"
    puts "Please choose a tile 1-9 that has not been taken yet"
    input = gets.chomp.to_i
  end
  board_arr[input-1] = player.symbol
  player.choices.push(input)
end

def winner?(player, player1, player2, board_arr)
  winning_combs = [[1,2,3],[4,5,6],[7,8,9],
                 [1,4,7],[2,5,8],[3,6,9],
                 [1,5,9],[3,5,7]]

  winning_combs.each do |winning|
    if winning - player.choices == []
      player.score += 1
      winning.each {|w| board_arr[w-1] = "⭐"}
      system("clear") || system("cls")
      puts display_board(board_arr)
      puts "#{player.name} has won!"
      if player1.name == "Player 1"
        puts "Player 1         #{player1.score} - #{player2.score}         Player 2"
      else
        puts "Player 1         #{player2.score} - #{player1.score}         Player 2"
      end
      return true
    end
  end

  if player1.choices.length + player2.choices.length == 9
    puts "Tie"
    if player1.name == "Player 1"
        puts "Player 1         #{player1.score} - #{player2.score}         Player 2"
      else
        puts "Player 1         #{player2.score} - #{player1.score}         Player 2"
      end
    return true
  end
  false
end

def display_board(board_arr)
        ["                ",
         "  #{board_arr[6]}  |  #{board_arr[7]}  |  #{board_arr[8]} ",
         "  ――――――――――――――",
         "  #{board_arr[3]}  |  #{board_arr[4]}  |  #{board_arr[5]} ",
         "  ――――――――――――――",
         "  #{board_arr[0]}  |  #{board_arr[1]}  |  #{board_arr[2]} ",
         "                "]
end

def start_round(board_arr, player1, player2)
  loop do
    puts display_board(board_arr)
    play(player1, board_arr)
    break if winner?(player1, player1, player2, board_arr)
    system("clear") || system("cls")
    
    puts display_board(board_arr)
    play(player2, board_arr)
    break if winner?(player2, player1, player2, board_arr)
    system("clear") || system("cls")
  end
end

loop do
  puts "#{player1.name} starts the game"
  start_round(board_arr, player1, player2)
  puts "Play again?"
  again = gets.chomp.downcase
  choices = ["yes", "y" ,"sure", "certainly", "indeed", "of course", "all right", "affirmative", 
  "yup", "yep", "yeah", "yea", "ok", "okay", "aye aye", "aye aye captain!","okey-dokey","uh-huh",
  "absolutely", "alright", "very well", "surely"] #I was bored
  break unless choices.include?(again)

  #reset game
  system("clear") || system("cls")
  board_arr = [1,2,3,4,5,6,7,8,9]
  player1.choices = []
  player2.choices = []
  player1, player2 = player2, player1
end




