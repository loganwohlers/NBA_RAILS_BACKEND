# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "TEST"
require_relative '../config/environment.rb'
require_relative '../lib/scrape.rb'

Season.destroy_all
Team.destroy_all
Player.destroy_all
PlayerSeason.destroy_all
Game.destroy_all
GameLine.destroy_all

    
##################################

season=2018

#create current season
test_season=Season.create(year: season, description: '2017-2018 NBA Season')
get_teams
get_players(test_season.year)


# #get all theplayers/player seasons

# team1=Team.first
# team2=Team.last
# test_schedule=schedule_check(test_season.year)
# opener=Game.first
# get_team_boxscore(opener)
# p GameLine.all
