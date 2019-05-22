require_relative '../config/environment.rb'

lebron=Player.find_by(name: "LeBron James")
ps=lebron.player_seasons.first

psx=ps.get_last_x_game_lines(10)

p psx



# def name_to_url(name)
#     name_arr=name.split(" ")
#     str=name_arr[1][0..4]+name_arr[0][0..1]
#     return str.downcase
# end

# url_name=name_to_url(p1)
# # https://www.basketball-reference.com/players/a/abrinal01.html

# mechanize=Mechanize.new
# player_url='https://www.basketball-reference.com/players/a/'+ url_name +'01.html'
# player_page=mechanize.get(player_url)
# info_div='#info'
# info = player_page.at(info_div)


# #getting text about players (ie age, height, birth, etc)
# info.search('p').each do |p|
#     text = p.text.strip
#     p text
# end

# #player img url
# img=info.search('img').attribute('src').value

# p img
