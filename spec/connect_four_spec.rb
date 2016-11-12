require 'connect_four'
require 'spec_helper'


describe ConnectFour do
  before(:each) do
    @game = ConnectFour.new
  end

  let(:player1) { "●" }
  let(:player2) { "○" }

  context "#initialize" do
    it "creates 6 x 7 board" do
      expect(@game.instance_variable_get(:@board)).to be_instance_of(Array)
      expect(@game.instance_variable_get(:@board)).to have_exactly(6).items
      expect(@game.instance_variable_get(:@board)).
        to all(be_instance_of(Array))
      expect(@game.instance_variable_get(:@board)).
      to all(have_exactly(7).items)
    end

    it "sets no winner" do
      expect(@game.instance_variable_get(:@winner)).to eq(nil)
    end

    it "sets current player to '●'" do
      expect(@game.instance_variable_get(:@current_player)).to eql(player1)
    end
  end


  describe "#play" do
    before(:each) do
      class ConnectFour
        def play
          loop do
            break if @winner || board_full?
            print_board
            next_move
            switch_players
          end
          finish_game
        end
      end

      allow(@game).to receive(:loop).and_yield
    end

    after(:each) do
        @game.play
    end

    context "when there is no winner" do
      before(:each) do
        @game.instance_variable_set(:@winner, nil)
      end

      context "and board is not full" do
        before(:each) do
          def @game.board_full?; false end
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
        before(:each) do
          def @game.board_full?; true end
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
      before(:each) do
        @game.instance_variable_set(:@winner, player1)
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


  describe "#board_full?" do
    context "when board is full" do
      before(:each) do
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

  describe "#print_board" do
    it "prints current state of board" do
      expect { @game.print_board }.to output.to_stdout
      expect(@game.instance_variable_get(:@board)).to receive(:each)
      @game.print_board
    end
  end

  describe "#switch_players" do
    context "when ● is current_player" do
      before(:each) { @game.instance_variable_set(:@current_player, "●") }

      it "switches current player to ○" do
        @game.switch_players
        expect(@game.instance_variable_get(:@current_player)).to eql("○")
      end
    end

    context "when ○ is current_player" do
      before(:each) { @game.instance_variable_set(:@current_player, "○") }

      it "switches current player to ●" do
        @game.switch_players
        expect(@game.instance_variable_get(:@current_player)).to eql("●")
      end
    end
  end


  describe "#finish_game" do
    after(:each) { @game.finish_game }

    it "prints final state of board" do
      expect(@game).to receive(:print_board)
    end

    context "when there is no winner" do
      it "prints 'Draw. Game over'" do
        expect { @game.finish_game }.to output(/Draw. Game over/).to_stdout
      end
    end

    context "when there is a winner" do
      context "when ○ wins" do
        before(:each) { @game.instance_variable_set(:@winner, "○") }
        it "prints congratulations for ○" do
          expect { @game.finish_game }.to output(/○/).to_stdout
        end
      end

      context "when ● wins" do
        before(:each) { @game.instance_variable_set(:@winner, "●") }
        it "prints congratulations for ●" do
          expect { @game.finish_game }.to output(/●/).to_stdout
        end
      end
    end
  end
end
