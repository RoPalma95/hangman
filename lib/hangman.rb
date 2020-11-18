require 'yaml'

class Hangman
  
  attr_accessor :game_mode, :word, :incorrect_guesses, :spaces, :guesses, :guessed_word, :saved
  attr_reader 

  @@WELCOME_MESSAGE = "\n\tWelcome to Hangman!
  \nPlease select an option:\n
  \t+ [N]ew Game
  \t+ [L]oad Game\n"

  def initialize
    system('clear') || system('cls')
    print @@WELCOME_MESSAGE
    @game_mode = select_mode
    set_game_parameters(game_mode)
  end

  def select_word(word = '')
    File.open('dictionary.txt', 'r') do |dictionary|
      while word.length < 5 || word.length > 12
        word = dictionary.readlines.sample.strip
        dictionary.rewind
      end
    end
    word.downcase
  end

  def select_mode
    mode = gets.chomp.downcase
    until mode == 'n' || mode == 'l'
      print "Please type 'N' or 'L'(case insensitive): "
      mode = gets.chomp.downcase
    end
    mode
  end

  def set_game_parameters(game_mode)
    if game_mode == 'n'
      @word = select_word
      @spaces = Array.new(word.length, '_ ')
      @guesses = []
      @incorrect_guesses = 10
      @guessed_word = false
      @saved = false
      new_game
    else
      load_game
    end
  end

  def new_game
    game until incorrect_guesses == 0 || guessed_word == true || saved == true
    unless saved == true
      game
      puts incorrect_guesses == 0 ? "\n\nYou lose! The correct word was #{word}." : "\n\nCongratulations! You guessed the word!"
    end
  end

  def game
    system('clear') || system('cls')
    puts "\n\tWelcome to Hangman!\n\nGuess the word correctly to win.\nType the word 'save' at any time to save your game.\n"
    if guesses.empty? == false && guesses.last.strip == 'save'
      save_game
      self.saved = true
    else
      display_spaces
      unless guessed_word == true || incorrect_guesses == 0
        make_guess
        check_guess
      end
    end
  end

  def display_spaces
    puts "\n\t#{spaces.join} \n"
    puts "\nYou have #{incorrect_guesses} incorrect guesses left."
    print "Your guesses: #{guesses.join}"
  end

  def make_guess
    self.guesses.push(gets.chomp.downcase + ' ')
  end

  def check_guess
    current_guess = guesses.last.strip
    if word.include?(current_guess)
      word.split('').each_with_index do |letter, index|
        letter == current_guess ? spaces[index] = letter : nil
      end
    else
      self.incorrect_guesses -= 1
    end
    spaces.include?("_ ") ? nil : self.guessed_word = true
  end

  def save_game
    system('clear') || system('cls')
    Dir.mkdir('save_files') unless Dir.exist?('save_files')
    File.open('./save_files/saved_game.yml', 'w') do |save_file|
      YAML.dump([] << self, save_file)
    end
    puts "Game Saved\n\n" ; sleep 1
  end

  def load_game
    system('clear') || system('cls')
    yaml = File.open('./save_files/saved_game.yml', 'r') { |save_file| YAML.load(save_file) }
    self.game_mode = yaml[0].game_mode
    self.word = yaml[0].word
    self.spaces = yaml[0].spaces
    self.guesses = yaml[0].guesses
    self.incorrect_guesses = yaml[0].incorrect_guesses
    self.guessed_word = yaml[0].guessed_word
    self.saved = yaml[0].saved

    self.guesses.pop
    puts 'Game Loaded'; sleep 1
    new_game
  end
end

Hangman.new