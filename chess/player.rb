require 'io/console'
require_relative 'board'
require_relative 'pieces'

class Player
  def play_turn
    raise NotImplementedError
  end
end

class HumanPlayer < Player

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    start_pos = get_start_pos(board)

    begin
      end_pos = get_end_pos(board)
      board.move(start_pos, end_pos)
    rescue ArgumentError => move_error
      error_prompt = move_error.message
      start_pos = get_start_pos(board, error_prompt)
      retry
    end
  end

  def get_start_pos(board, error_prompt = "")
    start_prompt = "Select the piece to move with spacebar. w-a-s-d move cursor."
    input = get_input(board, start_prompt, error_prompt)

    if board[input].nil? || board[input].color != self.color
      error_prompt = "That's not your piece!"
      get_start_pos(board, error_prompt)
    else

      input
    end
  end

  def get_end_pos(board)
    end_prompt = "Select where to move piece with spacebar. w-a-s-d move cursor."
    input = get_input(board, end_prompt)

    input
  end

  def get_input(board, prompt, error_prompt = "")
    #implements cursor on game board
    command = nil
    until command == ' '
      board.render_interface(prompt, error_prompt)

      command = STDIN.getch
      case command
      when 'w' then board.cursor_pos[0] -= 1 unless board.cursor_pos[0] - 1 < 0
      when 's' then board.cursor_pos[0] += 1 unless board.cursor_pos[0] + 1 > 7
      when 'a' then board.cursor_pos[1] -= 1 unless board.cursor_pos[1] - 1 < 0
      when 'd' then board.cursor_pos[1] += 1 unless board.cursor_pos[1] + 1 > 7
      when 'q' then exit
      end
    end

    board.cursor_pos.dup
  end

end

class ComputerPlayer < Player
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    pieces = board.find_pieces(color)
    piece = get_random_piece(board)

    if pieces.any? { |piece| piece.in_danger? }
      piece = pieces.select { |piece| piece.in_danger? }.shuffle.first
    end

    begin

    start_pos = piece.pos
    end_pos = piece.random_move

    end_pos = piece.attacking_moves.first unless piece.attacking_moves.empty?
    end_pos = piece.check_moves.first unless piece.check_moves.empty?

    board.move(start_pos, end_pos)
    rescue ArgumentError
      piece = get_random_piece(board)
      retry
    end

    board.render_interface
    sleep(0.1)
  end

  def get_random_piece(board)
    pieces = board.find_pieces(color)
    valid_move_pieces = pieces.select { |piece| piece.valid_moves.length > 0 }
    valid_move_pieces.shuffle.first
  end

end

class DumbComputerPlayer < ComputerPlayer

  def initialize(color)
    super
  end

  def play_turn(board)
    pieces = board.find_pieces(color)
    piece = get_random_piece(board)

    start_pos = piece.pos
    end_pos = piece.random_move

    board.move(start_pos, end_pos)

    system('clear')
    board.render
    puts "#{board.current_turn} turn"
    sleep(0.1)
  end
end
