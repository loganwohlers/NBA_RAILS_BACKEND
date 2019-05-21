Rails.application.routes.draw do
  resources :player_seasons
  resources :game_lines
  resources :games
  resources :teams
  resources :seasons
  resources :players

  resources :players do
    resources :player_seasons
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
