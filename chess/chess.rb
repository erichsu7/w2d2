require_relative 'board'
require_relative 'player'
require 'colorize'

class Chess

attr_reader :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:white)
    @player2 = ComputerPlayer.new(:black)
  end

  def play
    puts "Game on!"
    while true
      break if @board.checkmate?(player1.color)
      turn(player1)
      break if @board.checkmate?(player2.color)
      turn(player2)
    end

    @board.render
    puts "Game over!"
  end

  def turn(player)
    @board.toggle_turn
    player.play_turn(@board)
  end

end


game = Chess.new
game.play
