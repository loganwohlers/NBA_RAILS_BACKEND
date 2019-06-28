# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative '../config/environment.rb'
require_relative '../lib/scrape.rb'

#reset teams
#always same 30 teams 
# Team.destroy_all
# get_teams

#reset fn
def reset
    Season.destroy_all
    Player.destroy_all
    PlayerSeason.destroy_all
    Game.destroy_all
    GameLine.destroy_all
    TeamSeason.destroy_all
end
    
##################################

# reset()

season19=Season.find_or_create_by(year: 2019, description: '2018-2019 NBA Season')
# get_team_seasons(season19)
# get_players(season19)

get_schedule(season19)
get_season_stats(season19.games)


# seed_season(season19)
# season18=Season.create(year: 2018, description: '2017-2018 NBA Season')
# seed_season(season19)
