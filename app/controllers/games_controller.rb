require 'json'
require 'open-uri'

class GamesController < ApplicationController

  # def initialize
  # @word_array = []
  # end

  def new
    # used to display a new random grid and a form
    # The form will be submitted (with POST) to the score action
    @word_array = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @answer = params[:answer].upcase
    @word_array = params[:word_array].split("")

    # api check
    @dictionary_check = false
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    dict_serialized = URI.open(url).read
    dict_reply = JSON.parse(dict_serialized)
    @dictionary_check = dict_reply["found"]
    @word_length = dict_reply["length"]

    # include in array check
    @included_check = true
    answer_array = @answer.split("")
    answer_array.each do |letter|
      @included_check = answer_array.count(letter) <= @word_array.count(letter)
    end

    # won the game?
    @won = @dictionary_check && @included_check
    @score = @word_length * @word_length

  end


end
