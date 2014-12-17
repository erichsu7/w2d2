class Game
  attr_accessor :cpu, :guess_feedbacks

  def initialize
    @cpu = Code.random #object
    @guess_feedbacks = []
  end

  def accept_guess
    puts "Guess:"
    gets.chomp.upcase
  end

  def calc_matches(user) #object
    exact_matches = cpu.exact_matches(user)
    near_matches = cpu.near_matches(user)
    [exact_matches, near_matches]
  end

  def add_to_board(user_code, matches)
    feedback = "#{user_code}, Exact matches: #{matches[0]}, Near matches: #{matches[1]}"
    @guess_feedbacks << feedback
  end

  def render
    puts "Turn: #{guess_feedbacks.length+1}"
    @guess_feedbacks.each { |guess| puts guess }
  end

  def play
    until guess_feedbacks.length > 9
      render
      user_guess = Code.parse(accept_guess)
      matches = calc_matches(user_guess)
      add_to_board(user_guess.code, matches)
      if user_guess == @cpu
        puts "You win!"
        break
      end
    end
    puts "Sorry, better luck next time :)." if guess_feedbacks.length > 9
  end

end

class Code
   attr_accessor :code

  COLORS = %w( R G B Y O P )

  def initialize code
    @code = code
  end

  def self.random
    colors = []
    4.times { colors << COLORS.sample }
    Code.new colors
  end

  def self.parse(code_string_input)
    colors = code_string_input.split("")
    Code.new colors
  end

  def exact_matches(other_code)
    exact_matches = 0
    4.times do |i|
      exact_matches += 1 if self.code[i] == other_code.code[i]
    end
    exact_matches
  end

  def ==(other)
    self.code == other.code
  end

  def near_matches(other_code)
    # cpu_colors = color_freq(self.code)
    # human_colors = color_freq(other_code.code)
    near_matches = 0

    other_code.color_freq.each do |color, freq|
      if self.color_freq.has_key?(color)
        if other_code.color_freq[color] >= self.color_freq[color]
          near_matches += self.color_freq[color]
        else
          near_matches += other_code.color_freq[color]
        end
      end
    end
    near_matches - exact_matches(other_code)
  end

  def color_freq #expecting array
    color_freq = Hash.new(0)

    code.each do |color|
      color_freq[color] += 1
    end
    color_freq
  end
end

Game.new.play
