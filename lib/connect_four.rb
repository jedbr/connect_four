class ConnectFour
  def initialize
    @board = Array.new(7) { Array.new(6) }
    @current_player = "●"
    @last_move = {}
    @winner = nil
  end

  def play
    until @winner || board_full?
      switch_players
      print_board
      next_move
      @winner = @current_player if winner?
    end
    finish_game
  end

  def winner?
    return false if @last_move.empty?

    return true if vertical_check? ||
                   horizontal_check? ||
                   slash_check? ||
                   backslash_check?

    false
  end

  def vertical_check?
    match = []
    row = @last_move[:row]
    column = @last_move[:column]

    if row > 2
      (row - 3..row).each { |r| match << @board[column][r] }
    else
      (row..row + 3).each { |r| match << @board[column][r] }
    end

    match.uniq.size == 1
  end

  def horizontal_check?
    match = []
    row = @last_move[:row]
    column = @last_move[:column]

    if column > 2
      (column - 3..column).each { |c| match << @board[c][row] }
      return true if match.uniq.size == 1
    end

    if column < 4
      match = []
      (column..column + 3).each { |c| match << @board[c][row] }
    end

    match.uniq.size == 1
  end

  def slash_check?
    match = []
    row = @last_move[:row]
    column = @last_move[:column]

    if column > 2 && row > 2
      (-3..0).each { |i| match << @board[column + i][row + i] }
      return true if match.uniq.size == 1
    end

    if column < 3 && row < 3
      match = []
      (0..3).each { |i| match << @board[column + i][row + i] }
    end

    match.uniq.size == 1
  end

  def backslash_check?
    false
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
    system("clear")
    puts "1 | 2 | 3 | 4 | 5 | 6 | 7"
    (0..5).reverse_each do |i|
      to_print = []
      @board.each do |column|
        to_print << column[i]
      end
      puts to_print.map{ |i| i.nil? ? " " : i }.join(" | ")
    end
  end

  def next_move
    loop do
      puts "Choose column for next move, #{@current_player}"
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
    @last_move = {column: column, row: row}
  end

  def finish_game
    print_board
    if @winner
      puts "Congratulations, #{@winner} !"
    else
      puts "Draw. Game over"
    end
  end
end
