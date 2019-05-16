require_relative '../config/environment.rb'

lebron=Player.find_by(name: "LeBron James")
season=Season.first


p lebron
p season

# avg=lebron.get_season_averages(2017)
# puts
# p avg

# puts
# p lebron.player_seasons.first.game_lines.last

