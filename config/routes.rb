Rails.application.routes.draw do
  resources :player_seasons
  resources :game_lines
  resources :games
  resources :teams
  resources :seasons
  resources :players

  get '/seasons/:id?games=true', to: 'seasons#show'
  get '/seasons/:id?stats=true', to: 'seasons#show'

#  An incoming path of /photos/1?user_id=2 will be dispatched to the show action of the Photos controller. params will be { controller: 'photos', action: 'show', id: '1', user_id: '2' }.



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
