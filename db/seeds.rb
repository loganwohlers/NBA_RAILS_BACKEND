# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative '../config/environment.rb'
require_relative '../lib/scrape.rb'

#always same 30 teams 
# Team.destroy_all

Season.destroy_all
Player.destroy_all
PlayerSeason.destroy_all
Game.destroy_all
GameLine.destroy_all
TeamSeason.destroy_all
    
##################################

# seasons=[2016,2017,2018]

#seed one season
season=2018
test_season=Season.create(year: season, description: '2017-2018 NBA Season')
seed_season(test_season)

