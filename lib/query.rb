require_relative '../config/environment.rb'

lebron=Player.find_by(name: "LeBron James")
season=Season.first



avg=lebron.get_season_averages(2018)
games=lebron.get_all_games(2018)

p avg
puts

p games
p games.length
puts

