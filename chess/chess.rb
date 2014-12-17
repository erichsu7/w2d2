require_relative 'pieces'
require_relative 'board'
require_relative "stepping_piece"
require_relative "sliding_piece"

class Chess

attr_reader :board

  def initialize
    @board = Board.new
  end

end


game = Chess.new
board = game.board


black_king_pos = [1, 0]
white_queen_pos = [6, 6]
black_pawn_pos = [3, 5]

black_king = King.new(black_king_pos, board, :black)
white_queen = Queen.new(white_queen_pos, board, :white)
black_pawn = BlackPawn.new(black_pawn_pos, board)

board[black_king_pos] = black_king
board[white_queen_pos] = white_queen
dup_board = board.dup

dup_board[black_pawn_pos] = black_pawn

#king_pos = [3, 3]
#queen_pos = [5, 3]
#king = King.new(king_pos, board, :white)
#queen = Queen.new(queen_pos, board, :black)

#board[king_pos] = king
#board[queen_pos] = queen

board.rows.each {|row| p row}
dup_board.rows.each {|row| p row}



#p white_queen.moves
p board.in_check?(:black)
#p board.find_king(:black)

#p king.moves
#p queen.moves
