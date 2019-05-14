Rails.application.routes.draw do
  resources :nba_seasons
  resources :nba_games
  resources :nba_players
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
