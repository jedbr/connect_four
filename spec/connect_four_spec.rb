require 'connect_four'
require 'spec_helper'


describe ConnectFour do
  before do
    @game = ConnectFour.new
    allow(@game).to receive_message_chain(:gets, :chomp, :to_i) { rand(7) + 1 }
  end

  let(:player1) { "●" }
  let(:player2) { "○" }

  context "#initialize" do
    it "creates 7 x 6 board" do
      expect(@game.instance_variable_get(:@board)).to be_instance_of(Array)
      expect(@game.instance_variable_get(:@board)).to have_exactly(7).items
      expect(@game.instance_variable_get(:@board))
        .to all(be_instance_of(Array))
      expect(@game.instance_variable_get(:@board))
        .to all(have_exactly(6).items)
    end

    it "sets current player to '●'" do
      expect(@game.instance_variable_get(:@current_player)).to eql(player1)
    end
  end


  describe "#play" do
    before do
      class ConnectFour
        def play
          loop do
            break if winner? || board_full?
            switch_players
            print_board
            next_move
          end
          finish_game
        end
      end

      allow(@game).to receive(:loop).and_yield
    end

    after do
        @game.play
    end

    context "when there is no winner" do
      before do
        expect(@game).to receive(:winner?) { false }
      end

      context "and board is not full" do
        before do
          expect(@game).to receive(:board_full?) { false }
        end

        it "prints current state of board" do
          expect(@game).to receive(:print_board).at_least(:once)
        end

        it "asks current player for next move" do
          expect(@game).to receive(:next_move)
        end

        it "swaps current player" do
          expect(@game).to receive(:switch_players)
        end
      end

      context "and board is full" do
        before do
          expect(@game).to receive(:board_full?) { true }
        end

        it "does not ask current player for next move" do
          expect(@game).not_to receive(:next_move)
        end

        it "does not swap current player" do
          expect(@game).not_to receive(:switch_players)
        end

        it "ends game" do
          expect(@game).to receive(:finish_game)
        end
      end
    end

    context "when there is a winner" do
      before do
        expect(@game).to receive(:winner?) { true }
      end

      it "does not ask current player for next move" do
        expect(@game).not_to receive(:next_move)
      end

      it "does not swap current player" do
        expect(@game).not_to receive(:switch_players)
      end

      it "ends game" do
        expect(@game).to receive(:finish_game)
      end
    end
  end


  describe "#winner?" do
    context "when someone wins" do
      before do
        board = Array.new(7) { Array.new(6) }
        board[1][1] = player1
        board[2][2] = player1
        board[3][3] = player1
        board[4][4] = player1
        last_move = {column: 2, row: 2}
        @game.instance_variable_set(:@board, board)
        @game.instance_variable_set(:@last_move, last_move)
      end

      it "returns true" do
        expect(@game.winner?).to be
      end
    end

    context "when noone wins" do
      it "returns false" do
        expect(@game.winner?).not_to be
      end
    end
  end


  describe "#board_full?" do
    context "when board is full" do
      before do
        @game.instance_variable_set(:@board, Array.new(7) do
          Array.new(6) { player1 }
        end)
      end

      it "returns true" do
        expect(@game.board_full?).to be
      end
    end

    context "when board is not full" do
      it "returns false" do
        expect(@game.board_full?).not_to be
      end
    end
  end


  describe "#switch_players" do
    context "when ● is current_player" do
      before { @game.instance_variable_set(:@current_player, "●") }

      it "switches current player to ○" do
        @game.switch_players
        expect(@game.instance_variable_get(:@current_player)).to eql("○")
      end
    end

    context "when ○ is current_player" do
      before { @game.instance_variable_set(:@current_player, "○") }

      it "switches current player to ●" do
        @game.switch_players
        expect(@game.instance_variable_get(:@current_player)).to eql("●")
      end
    end
  end


  describe "#print_board" do
    it "prints current state of board" do
      expect { @game.print_board }.to output.to_stdout
    end
  end


  describe "#next_move" do
    it "asks player for next move" do
      expect { @game.next_move }.to output.to_stdout
    end

    it "takes number between 1 - 7 as column index" do
      expect(@game).to receive_message_chain(:gets, :chomp, :to_i) { rand(7) + 1 }
      @game.next_move
    end
  end


  describe "#finish_game" do
    after { @game.finish_game }

    it "prints final state of board" do
      expect(@game).to receive(:print_board)
    end

    context "when there is no winner" do
      it "prints 'Draw. Game over'" do
        expect { @game.finish_game }.to output(/Draw/i).to_stdout
      end
    end

    context "when there is a winner" do
      context "when ○ wins" do
        before() { @game.instance_variable_set(:@winner, "○") }
        it "prints congratulations for ○" do
          expect { @game.finish_game }.to output(/○/).to_stdout
        end
      end

      context "when ● wins" do
        before() { @game.instance_variable_set(:@winner, "●") }
        it "prints congratulations for ●" do
          expect { @game.finish_game }.to output(/●/).to_stdout
        end
      end
    end
  end
end
