class SeasonsController < ApplicationController

     def index

          render json: @Season.all
     end

     def show
          @season=Season.find_by(year: params[:id])
          render json: @season
     end

   end