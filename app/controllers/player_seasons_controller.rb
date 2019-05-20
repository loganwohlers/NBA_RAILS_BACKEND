class PlayerSeasonsController < ApplicationController

     def index
          @players=PlayerSeason.all
          render json: @players
     end

   end