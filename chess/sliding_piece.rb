require_relative "pieces.rb"

class SlidingPiece < Piece

  attr_accessor :diagonals, :orthogonals

  def initialize(pos, board, color)
    super
  end

  def moves
    moves = []
    self.class.move_directions.each do |direction|
      stop_search = false

      d_row, d_col = direction
      i = 1

      until stop_search
        scaled_dir = [d_row * i, d_col * i]

        new_pos = pos[0] + scaled_dir[0], pos[1] + scaled_dir[1]
        if Board.on_board?(new_pos)
          moves << new_pos if (board[new_pos].nil? || board[new_pos].color != self.color)

          next_scaled_dir = [d_row * (i + 1), d_col * (i + 1)]
          next_pos = pos[0] + next_scaled_dir[0], pos[1] + next_scaled_dir[1]

          stop_search = true if !board[new_pos].nil? || !Board.on_board?(next_pos)
          i += 1
        else
          stop_search = true
        end
      end
    end
    moves
  end

end

class Queen < SlidingPiece

  def initialize(pos, board, color)
    super
  end

  def self.move_directions
    ORTHOGONALS + DIAGONALS
  end

end

class Rook < SlidingPiece

  def initialize(pos, board, color)
    super
  end

  def self.move_directions
    ORTHOGONALS
  end

end

class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super
  end

  def self.move_directions
    DIAGONALS
  end

end
