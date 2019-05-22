class GamesController < ApplicationController

     def index
          @games=Game.all
          render json: @games
     end

     def show
          @game=Game.find(params[:id])
          render json: @game.game_lines
     end

end