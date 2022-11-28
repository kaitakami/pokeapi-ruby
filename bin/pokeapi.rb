# frozen_string_literal: true

require 'net/http'
require 'json'

# API class
class API
  attr_reader :pokemons

  def fetch_pokemons
    uri = URI('https://pokeapi.co/api/v2/pokemon')
    @pokemons = JSON.parse(Net::HTTP.get(uri))['results']
    pokemons.map { |pokemon| pokemon['name'] }
  end

  def fetch_pokemon_api(pokemon_endpoint)
    pokemon_uri = URI(pokemon_endpoint)
    JSON.parse(Net::HTTP.get(pokemon_uri))
  end
end

API.new.fetch_pokemons

# PokeApi class
class PokeApi
  def initialize
    @user_pokemon = select_pokemon
  end

  def select_pokemon
    pokemon_names = API.new.fetch_pokemons
    pokemon_names.each_with_index { |name, i| puts "Type #{i} if you want #{name}" }

    print 'Select your pokemon: '
    id = gets.chomp.to_i
    get_pokemon_details(id, pokemon_names)
  end

  def get_pokemon_details(id, pokemon_names)
    if id.between?(0, pokemon_names.length - 1)
      puts "Nice! You selected #{pokemon_names[id]}"
      pokemon_endpoint = API.new.pokemons[id]['endpoint']
      take_important_details(API.new.fetch_pokemon_api(pokemon_endpoint))
    else
      puts 'Error! :('
      puts ":Your Input was: #{id} \n Try Again..."
      select_pokemon
    end
  end

  def take_important_details(pokemon_information)
    p pokemon_information
  end

  private

  attr_reader :user_pokemon
end

PokeApi.new
