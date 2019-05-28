class SeasonsController < ApplicationController

    def index
        render json: Season.all.order(year: :asc)
     end

     def show
        #currently passing a hardcoded yr str
        if(params[:stats])
            @season=Season.find_by(year: params[:id])
            render json: @season.player_seasons
        elsif (params[:games])
            @season=Season.find_by(year: params[:id])
            render json: @season.games
        end
     end
end