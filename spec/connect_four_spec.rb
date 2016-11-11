require 'connect_four'
require 'spec_helper'


describe ConnectFour do
  before(:each) do
    @game = ConnectFour.new
  end

  let(:player1) { "●" }
  let(:player2) { "○" }

  context "#initialize" do
    it "creates board" do
      expect(@game.instance_variable_get(:@board)).to be_instance_of(Array)
      expect(@game.instance_variable_get(:@board)).to have_exactly(7).items
      expect(@game.instance_variable_get(:@board)).
        to all(be_instance_of(Array))
      expect(@game.instance_variable_get(:@board)).
      to all(have_exactly(6).items)
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
          expect(@game).to receive(:print_board)
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

        it "does not print current state of board" do
          expect(@game).not_to receive(:print_board)
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

      it "does not print current state of board" do
        expect(@game).not_to receive(:print_board)
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
end
