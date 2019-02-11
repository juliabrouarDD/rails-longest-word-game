require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @grid = params[:grid].split('')
    @user_input = params[:word]
    @score = 0
    if included?(@user_input, @grid)
      if english_word?(@user_input)
        @score += @user_input.size
        return @result = "Congatulations! #{@user_input} is a valid English word"
      else
        @result = "Sorry but #{@user_input} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{@user_input} can\'t be build out of #{@grid.join(', ')}"
    end
  end
end

def included?(word, letters)
  word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
end

def english_word?(user_input)
  response = open("https://wagon-dictionary.herokuapp.com/#{user_input}")
  json = JSON.parse(response.read)
  json['found']
end
