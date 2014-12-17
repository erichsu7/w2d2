class Board

  attr_reader :rows

  def initialize
    @rows = Array.new(8) { Array.new(8) }

    populate_board
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @rows[row][col] = piece
  end

  def empty?(pos)
    [pos].nil?
  end

  def self.on_board?(pos)
    pos[0] >= 0 && pos[0] <= 7 && pos[1] >= 0 && pos[1] <= 7
  end

  def populate_board
  end
  #
  def in_check?(color)
    king_pos = find_king_pos(color)
    other_color = color == :black ? :white : :black
    pieces = find_pieces(other_color)
    pieces.any? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def find_pieces(color)
    pieces = []
    (0..7).each do |row_index|
      (0..7).each do |col_index|
        position = row_index, col_index
        potential_piece = self[position]
        pieces << potential_piece if potential_piece.is_a?(Piece) && potential_piece.color == color
      end
    end

    pieces
  end

  def find_king_pos(color)
    pieces = find_pieces(color)
    king = pieces.select { |piece| piece.is_a?(King) }
    king[0].pos
  end

  def move(start_pos, end_pos)
    raise ArgumentError, "No piece at start position" if self[start_pos].nil?
    raise ArgumentError, "Can't move to end position" unless piece.valid_moves.include?(end_pos)

    self[end_pos] = piece
    self[start_pos] = nil

    true
  end

  def dup
    copy_board = Board.new

    (0..7).each do |row_index|
      (0..7).each do |col_index|
        pos = [row_index, col_index]
        next if self[pos].nil?

        piece = self[pos]
        color = piece.color
        dup_piece = piece.class.new(pos, copy_board, color)

        copy_board[pos] = dup_piece
      end
    end

    copy_board
  end


end
