class PlayersController < ApplicationController

     def index
          @players=Player.all.order(name: :asc)
          render json: @players
     end

    
   end