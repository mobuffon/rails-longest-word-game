require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = Array.new(9) { ('A'..'Z').to_a.sample }
    @t = Time.now
  end

  def score
    @word = params[:word]
    @lenght = word_length
    @valid = english_word?
    @grid = params[:letters].split(' ')
    if included?
      if @valid
        b = Time.now
        @total_time = b - Time.parse(params[:time])
        score = computed_score
        @message = "Well done your score is #{score} it took you #{@total_time.round(2)} seconds and your word has #{@lenght} letters "
      else
        @message = 'sadly this is not an english word. Try again!'
      end
    else
      @message = 'This word is not in the grid. Try agin!'
    end
  end
end

def included?
  @word.each_char.to_a.all? { |letter| @word.upcase.count(letter) <= @grid.count(letter) }
end

def english_word?
  response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
  json = JSON.parse(response.read)
  json['found']
end

def word_length
  response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
  json = JSON.parse(response.read)
  json['lenght']
end

def computed_score
  (@word.size * (100 - @total_time)).round
end
