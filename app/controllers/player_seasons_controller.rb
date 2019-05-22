class PlayerSeasonsController < ApplicationController

     def index
               @players=PlayerSeason.all
               render json: @players
     end

     def show
          @player_season=PlayerSeason.find(params[:id])
          render json: @player_season.last_x_games(10)
     end

   end