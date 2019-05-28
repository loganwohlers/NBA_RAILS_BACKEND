class PlayersController < ApplicationController

     def index
          @players=Player.all.order(name: :asc)
          render json: @players
     end

     def show
          @player=Player.find(params[:id])
          render json: @player.get_player_summary
     end

   end