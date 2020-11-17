# on boot, load "dictionary.txt" and select a word between 5 and 12 characters long
require 'pry'

class Hangman
  private

  attr_accessor :incorrect_guesses, :spaces, :guesses, :guessed_word
  attr_reader :word, :game_mode

  public

  @@WELCOME_MESSAGE = "\n\tWelcome to Hangman!
  \nPlease select an option:\n
  \t+ [N]ew Game
  \t+ [L]oad Game\n"

  def initialize
    system('clear') || system('cls')
    print @@WELCOME_MESSAGE
    @game_mode = select_mode
    game_mode == 'n' ? new_game : load_game
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

  def new_game
    @word = select_word
    @spaces = Array.new(word.length, '_ ')
    @guesses = []
    @incorrect_guesses = 10
    @guessed_word = false
    game until incorrect_guesses == 0 || guessed_word == true
    game
    puts incorrect_guesses == 0 ? "\n\nYou lose! The correct word was #{word}." : "\n\nCongratulations! You guessed the word!"
  end

  def game
    system('clear') || system('cls')
    puts "\n\tWelcome to Hangman!\n\nGuess the word correctly to win.\nType the word 'save' at any time to save your game.\n"
    if guessed_word == true || incorrect_guesses == 0
      display_spaces
    else
      display_spaces
      make_guess
      check_guess
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
    SaveFile.save_game()
  end

  def load_game
    system('clear') || system('cls')
    puts "game loaded"
  end
end

Hangman.new
