json.array!(@pokemons) do |pokemon|
  json.extract! pokemon, :id, :name, :image_url
  json.url pokemon_url(pokemon, format: :json)
end
