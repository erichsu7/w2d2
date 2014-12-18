require_relative 'sliding_piece'
require_relative 'piece'

class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♝ : :♗
  end

  def self.move_directions
    DIAGONALS
  end

end
