require_relative 'sliding_piece.rb'
require_relative 'piece'

class Queen < SlidingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♛ : :♕
  end

  def self.move_directions
    ORTHOGONALS + DIAGONALS
  end

end
