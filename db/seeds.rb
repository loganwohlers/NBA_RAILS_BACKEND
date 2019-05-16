# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative '../config/environment.rb'
require_relative '../lib/scrape.rb'

# Team.destroy_all
#always same 30 teams 

Season.destroy_all
Player.destroy_all
PlayerSeason.destroy_all
Game.destroy_all
GameLine.destroy_all
TeamSeason.destroy_all
    
##################################

#seed one season
season=2018
test_season=Season.create(year: season, description: '2017-2018 NBA Season')

get_team_seasons(test_season)

# get_players(test_season.year)
# get_schedule(test_season.year)
# #left off here: WORKING!
# get_season_stats(Game.all)

#testing from last night

# gg=Game.find_by(code: '201710180WAS')
# puts gg.code
# mechanize=Mechanize.new
# get_team_boxscore(gg, gg.home_team_id, mechanize)
# get_team_boxscore(gg, gg.away_team_id, mechanize)

# team1=Team.first
# team2=Team.last
# test_schedule=schedule_check(test_season.year)
# opener=Game.first
# get_team_boxscore(opener)
# p GameLine.all
