require_relative 'stepping_piece'
require_relative 'piece'

class King < SteppingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♚ : :♔
  end

  def self.move_directions
    ORTHOGONALS + DIAGONALS
  end

end
