require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    # Set the session score to 0 on first go
    session["score"] = 0 unless session["score"]
    @score = session["score"]
  end

  def score
    guessed_letters = params[:guessed_letters].upcase
    given_letters = params[:given_letters]

    if !english_word?(guessed_letters)
      @result = "Sorry, but #{guessed_letters} is does not seem to be a valid English word..."
    elsif can_be_built?(guessed_letters, given_letters)
      @result = "Congratulations! #{guessed_letters} is a valid English word!"
      session["score"] += guessed_letters.length
    else
      @result = "Sorry but #{guessed_letters} cannot be built out of #{given_letters.split('').join(", ")}"
    end
    @score = session["score"]
  end

  private

  def letters_to_frequencies(letter_str)
    frequencies = Hash.new(0)
    letter_str.split('').each do |letter|
      frequencies[letter.to_sym] += 1
    end
    frequencies
  end

  def can_be_built?(guessed_letters, given_letters)
    guessed_letter_freq = letters_to_frequencies(guessed_letters)
    given_letter_freq = letters_to_frequencies(given_letters)

    guessed_letter_freq.map { |l, freq| freq <= given_letter_freq[l] }.all?
  end

  def english_word?(guessed_letters)
    url = "https://wagon-dictionary.herokuapp.com/#{guessed_letters}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word["found"]
  end
end
