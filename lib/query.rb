require_relative '../config/environment.rb'

lebron=Player.find_by(name: "LeBron James")


p lebron

avg=lebron.get_season_averages(2017)
p avg

teams=lebron.get_all_teams

p teams