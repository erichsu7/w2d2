require_relative 'stepping_piece'
require_relative 'piece'

class Knight < SteppingPiece

  def initialize(pos, board, color)
    super
    @symbol = self.color == :black ? :♞ : :♘
  end

  def self.move_directions
    [
      [2, 1],
      [1, 2],
      [-2, 1],
      [-1, 2],
      [2, -1],
      [1, -2],
      [-2, -1],
      [-1, -2]
    ]
  end
end
