class ConnectFour
  def initialize
    @board = Array.new(7) { Array.new(6) }
    @winner = nil
    @current_player = "●"
  end

  def play
    until @winner || board_full?
      print_board
      next_move
      switch_players
    end
    finish_game
  end

  def board_full?
    full = true
    @board.each do |column|
      full = false unless column.all?
    end
    full
  end

  def print_board

  end

  def next_move

  end

  def switch_players

  end

  def finish_game

  end
end