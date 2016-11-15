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
      (0..row).each do |r|
        match << @board[column][r]
      end
    else
      return false
    end

    match_check?(match)
  end

  def horizontal_check?
    match = []
    row = @last_move[:row]

    @board.each do |col|
      match << col[row]
    end

    return false if match.count { |x| x } < 4
    match_check?(match)
  end

  def slash_check?
    match = []
    row = @last_move[:row]
    column = @last_move[:column]

    while row >= 0 && column >= 0
      match << @board[column][row]
      row -= 1
      column -= 1
    end

    match.reverse!
    row = @last_move[:row] + 1
    column = @last_move[:column] + 1

    while row <= 5 && column <= 6
      match << @board[column][row]
      row += 1
      column += 1
    end

    return false if match.count { |x| x } < 4
    match_check?(match)
  end

  def backslash_check?
    match = []
    row = @last_move[:row]
    column = @last_move[:column]

    while row <= 5 && column >= 0
      match << @board[column][row]
      row += 1
      column -= 1
    end

    match.reverse!
    row = @last_move[:row] - 1
    column = @last_move[:column] + 1

    while row >= 0 && column <= 6
      match << @board[column][row]
      row -= 1
      column += 1
    end

    return false if match.count { |x| x } < 4
    match_check?(match)
  end

  def match_check?(match)
    last_item = nil
    streak = 1
    match.each do |i|
      if i.nil?
        last_item = i
        streak = 1
      elsif i == last_item
        streak += 1
      else
        last_item = i
        streak = 1
      end

      return true if streak == 4
    end

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
