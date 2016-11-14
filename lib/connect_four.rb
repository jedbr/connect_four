class ConnectFour
  def initialize
    @board = Array.new(7) { Array.new(6) }
    @current_player = "● "
  end

  def play
    until winner? || board_full?
      switch_players
      print_board
      next_move
    end
    finish_game
  end

  def winner?

  end

  def board_full?
    full = true
    @board.each do |column|
      return false unless column.all?
    end
    full
  end

  def switch_players
    @current_player = @current_player == "○ " ? "● " : "○ "
  end

  def print_board
    (0..5).reverse_each do |i|
      to_print = []
      @board.each do |column|
        to_print << column[i]
      end
      puts to_print.join(" | ")
    end
  end

  def next_move
    loop do
      puts "What your next move, #{@current_player} ?"
      i = gets.chomp.to_i
      if i.between?(1, 7) && !@board[i - 1].all?
        make_move(i - 1)
        break
      end
      puts "Invalid move. Try again."
    end
  end

  def make_move(column)
    row = @board[column].find_index(nil)
    @board[column][row] = @current_player
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
