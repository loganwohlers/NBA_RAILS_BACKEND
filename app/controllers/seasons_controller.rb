class SeasonsController < ApplicationController

    def index
        render json: Season.all.order(year: :asc)
     end


     #uses query string params to decide which class methods to return.  as games belong to a season we can simply call season.games.  if we want player averages we use the filter_player_seasons class method
     def show
        if(params[:stats])
            @season=Season.find_by(year: params[:id])
            @player_seasons=@season.filter_player_seasons
            render json: @player_seasons
        elsif (params[:games])
            @season=Season.find_by(year: params[:id])
            render json: @season.games
        end
     end
end