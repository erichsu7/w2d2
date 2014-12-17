require_relative "board"

class Piece
  attr_accessor :pos, :board, :color, :moves

  DIAGONALS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  ORTHOGONALS = [[0, 1], [1, 0], [0, -1], [-1, 0]]

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def inspect
    { :name => self.class, :pos => @pos, :color => @color }
  end

  def valid_moves
  end

  def move_into_check?(pos)

  end

end

class Pawn < Piece

  attr_reader :has_moved

  def initialize(pos, board, color)
    super
    @has_moved = false
  end

end

class BlackPawn < Pawn

  def initialize(pos, board, color = :black)
    super
  end

  def self.move_directions
    [
      [1, 0],
      [2, 0],
      [1, -1],
      [1, 1]
    ]
  end

  def moves
    @moves = []

    self.class.move_directions.each do |direction|
      new_pos = pos[0] + direction[0], pos[1] + direction[1]

      if Board.on_board?(new_pos)
        if board[new_pos].nil?
          if direction == [1, 0]
            @moves << new_pos if board[new_pos].nil?
          elsif direction == [2, 0] && self.has_moved == false
            position_in_front = pos[0] + 1, pos[1]
            @moves << new_pos if board[new_pos].nil? && board[position_in_front].nil?
          end
        else
          if direction == [1, -1] || direction == [1, 1]
            @moves << new_pos if board[new_pos].color != self.color
          end
        end
      end
    end

    @moves
  end

end

class WhitePawn < Pawn

  def initialize(pos, board, color = :white)
    super
  end

  def self.move_directions
    [
      [-1, 0],
      [-2, 0],
      [-1, -1],
      [-1, 1]
    ]
  end

  def moves
    @moves = []

    self.class.move_directions.each do |direction|
      new_pos = pos[0] + direction[0], pos[1] + direction[1]

      if Board.on_board?(new_pos)
        if direction == [-1, 0]
          @moves << new_pos if board[new_pos].nil?
        elsif direction == [-2, 0] && self.has_moved == false
          position_in_front = pos[0] - 1, pos[1]
          @moves << new_pos if board[new_pos].nil? && board[position_in_front].nil?
        elsif direction == [-1, -1] || direction == [-1, 1]
          @moves << new_pos if !board[new_pos].nil? && board[new_pos].color != self.color
        end
      end
    end
    @moves
  end

end
