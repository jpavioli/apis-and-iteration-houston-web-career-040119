#!/usr/bin/env ruby

require_relative "../lib/api_communicator.rb"
require_relative "../lib/command_line_interface.rb"

require 'rest-client'
require 'json'
require 'pry'

character_data = RestClient.get('http://swapi.co/api/people/1')
character_hash = JSON.parse(character_data)

def welcome_fun
  puts "Welcome to this Star Wars API demo!"
end

def get_character
  puts "Please enter a character"
  character = gets.chomp
  puts "User Entered #{character}"
  puts "*" * 30
  character
end

def get_films(user_character,character_hash)
  film_api_list =[]
  character_hash.find do |key,value|
    if key == "name" && value == user_character
      film_api_list << character_hash["films"]
    end
  end
  film_api_list.flatten
end

def get_film_name(film_api_list)
  film_api_list.map do |movie|
    film_hash = JSON.parse(RestClient.get("#{movie}"))
    film_hash["title"]
  end
end

welcome_fun
user_character = nil
until user_character == "exit" do
  user_character = get_character
  film_api_list = get_films(user_character,character_hash)
  if film_api_list != []
    film_list = get_film_name(film_api_list)
    puts "#{user_character} makes an apearance in the following movies!"
    puts film_list
  elsif user_character == "exit"
    puts "Thanks for using the Star Wars API demo!"
  else
    puts "#{user_character} is not in a Star Wars movie!"
  end
  puts "*" * 30
end
