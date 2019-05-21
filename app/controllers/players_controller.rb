class PlayersController < ApplicationController

     def index
          @players=Player.all.order(name: :asc)
          render json: @players
     end

     def show
          @player=Player.find(params[:id])
          #currently hardcoded to 2018
          # @player_season=@player.get_player_season(2018)
          # _season.game_lines.limit(10)
          render json: @player
     end

   end