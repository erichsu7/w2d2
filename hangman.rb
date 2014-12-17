class Hangman
  attr_accessor :checker, :guesser, :wrong_guesses, :right_guesses

  def initialize
    @checker = ComputerPlayer.new
    @guesser = HumanPlayer.new
    @wrong_guesses, @right_guesses = [], []
  end

  def play
    word_length = @checker.pick_secret_word_length
    @guesser.receive_secret_length(word_length)
    puts "New Game"
    puts "There are #{word_length} letters in the word. Good luck!"
    while !won? && @wrong_guesses.length < 10

      begin
        guess = @guesser.guess_letter
      rescue ArgumentError => error
        puts error.message
        retry
      end

      positions = @checker.tell_positions(guess)
      process_guess(@guesser, guess, positions)
      render(@guesser)
    end
      puts "You guessed the secret word!" if won?
      puts "The secret word is: #{@guesser.secret_word.join}"
  end

  def won?
    !@guesser.secret_word.include?("_")
  end

  def lost?
    @wrong_guesses.length >= 10
  end

  def process_guess(player, guess, positions)
    if positions.length > 0
      positions.each do |pos|
        player.secret_word[pos] = guess
      end
      right_guesses << guess
      puts "You guessed correctly!"
      if player.is_a?(ComputerPlayer)
        @guesser.select_word_by_position(guess, positions)
      end
    else
      wrong_guesses << guess
      puts "You chose poorly!"
    end
  end

  def render(guessing_player)
    puts "You have made #{@wrong_guesses.length} wrong guess(es) out of 10."
    print "Correct guesses: #{guessing_player.secret_word.join}\n"
    puts "Incorrect guesses: #{@wrong_guesses.sort.join(" ")}"
  end

end

class HumanPlayer

  attr_accessor :right_guesses, :wrong_guesses
  attr_reader :secret_word, :dictionary

  LETTERS = ("a".."z").to_a

  def initialize
    @secret_word = []
    @my_guesses = []
  end

  def receive_secret_length(secret_length)
    secret_length.times do |i|
      @secret_word[i] = "_"
    end
  end

  def tell_positions(letter)
    puts "Does your word include #{letter}? (y/n)"
    answer = gets.chomp.downcase
    if answer == "y"
      puts "What position(s) does the letter occur in the word? Separate indices by spaces."
      positions = gets.chomp.split.map { |position| position.to_i }
    else
      positions = []
    end
    positions
  end

  def pick_secret_word_length
    puts "What is the length of your secret word?"
    @secret_word_length = gets.chomp.to_i
  end

  def guess_letter
    puts "Guess a letter:"
    guess = gets.chomp.downcase
    raise ArgumentError, "You've already guessed #{guess}" if @my_guesses.include?(guess)
    raise ArgumentError, "#{guess} is not a valid letter" unless LETTERS.include?(guess)

    @my_guesses << guess
    guess
  end


end

class ComputerPlayer
  attr_accessor :my_guesses
  attr_reader :secret_word

  LETTERS = ("a".."z").to_a
  DICTIONARY = File.readlines("dictionary.txt")

  def initialize
    @secret_word = []
    @my_guesses = []
    @dictionary = DICTIONARY.map {|word| word.chomp}
  end

  def receive_secret_length(secret_length)
    secret_length.times do |i|
      @secret_word[i] = "_"
    end
  end

  def pick_secret_word_length
    @secret_word = DICTIONARY.sample.chomp.split("")
    @secret_word.length
  end

  # def guess_letter
  #   guess = ""
  #   until !@my_guesses.include?(guess) && guess != ""
  #     guess = LETTERS.sample
  #   end
  #   @my_guesses << guess
  #   guess
  # end

  def subset_dict
    @dictionary.select! { |word| word.length == @secret_word.length }
  end

  def select_word_by_position(letter, positions)
    @dictionary.select! do |word|
      positions.all? { |pos| word[pos] == letter }
    end
  end


  def guess_letter
    guess = ""
    subset_dict if @my_guesses.empty?
    letter_freqs = letter_freq_in_dict
    letter_freqs.each do |letter, freq|
      if !@my_guesses.include?(letter)
        guess = letter
        break
      end
    end

    @my_guesses << guess
    guess

  end

  def letter_freq_in_dict
    letter_freq = Hash.new(0)
    @dictionary.join.each_char do |letter|
      letter_freq[letter] += 1
    end
    letter_freq.sort_by {|letter, freq| freq}.reverse
  end

  def tell_positions(letter)
    positions = []
    if secret_word.include?(letter)
      secret_word.each_with_index do |char, position|
        positions << position if char == letter
      end
    end
    positions
  end

end

game = Hangman.new
game.play()
