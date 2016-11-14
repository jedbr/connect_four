class ConnectFour
  def initialize
    @board = Array.new(6) { Array.new(7) }
    @winner = nil
    @current_player = "●"
  end

  def play
    until @winner || board_full?
      switch_players
      print_board
      next_move
      winner_check
    end
    finish_game
  end

  def board_full?
    full = true
    @board.each do |column|
      return false unless column.all?
    end
    full
  end

  def switch_players
    @current_player = @current_player == "○" ? "●" : "○"
  end

  def print_board
    @board.each do |column|
      puts column.join("|")
    end
  end

  def next_move
    puts "What your next move, #{@current_player} ?"
    loop do
      i = gets.chomp
      if i.to_i.between?(1, 7)
        make_move
        break
      end
    end
  end

  def make_move

  end

  def winner_check

  end

  def finish_game
    print_board
    if @winner
      puts "Congratulations, #{@winner}!"
    else
      puts "Draw. Game over"
    end
  end
end
