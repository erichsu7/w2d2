
class Piece
  attr_accessor :pos, :board, :color, :moves, :symbol

  DIAGONALS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  ORTHOGONALS = [[0, 1], [1, 0], [0, -1], [-1, 0]]

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def inspect
    self.symbol
  end

  def valid_moves
    moves.select { |move| !move_into_check?(move) }
  end

  def random_move
    valid_moves.shuffle.first
  end

  def attacking_moves
    valid_moves.select do |move|
      next if board[move].nil?
      board[move].color != color
    end
  end

  def check_moves
    valid_moves.select do |move|
      next if board[move].nil?
      move_opponent_into_check?(move)
    end
  end

  def move_into_check?(end_pos)
    copy_board = board.dup
    copy_board.move!(self.pos, end_pos)
    copy_board.in_check?(color)
  end

  def move_opponent_into_check?(end_pos)
    other_color = color == :black ? :white : :black
    copy_board = board.dup
    copy_board.move!(self.pos, end_pos)
    copy_board.in_check?(other_color)
  end

  def in_danger?
    other_color = color == :black ? :white : :black
    other_pieces = board.find_pieces(other_color)
    other_pieces.any? do |other_piece|
      other_piece.valid_moves.include?(pos)
    end
  end

end
