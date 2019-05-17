require_relative '../config/environment.rb'

lebron=Player.find_by(name: "LeBron James")
season=Season.first

avg=lebron.get_player_season(2018)

p avg
puts


