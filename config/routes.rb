Rails.application.routes.draw do
  resources :pokemons
  resources :charges
  post 'checkout', to: 'pokemons#checkout' 
  get 'customers', to: 'pokemons#customers' 
end
