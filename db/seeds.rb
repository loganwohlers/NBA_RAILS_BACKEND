# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative '../config/environment.rb'

$team_codes={
    'Atlanta Hawks'=>'ATL',
    'Boston Celtics' => 'BOS',
    'Brooklyn Nets' => 'BRK',
    'Charlotte Hornets'=>'CHO',
    'Chicago Bulls'=>'CHI',
    'Cleveland Cavaliers'=>'CLE',
    'Dallas Mavericks'=>'DAL',
    'Denver Nuggets'=>'DEN',
    'Detroit Pistons'=>'DET',
    'Golden State Warriors'=>'GSW',
    'Houston Rockets'=>'HOU',
    'Indiana Pacers'=>'IND',
    'Los Angeles Clippers'=>'LAC',
    'Los Angeles Lakers'=>'LAL',
    'Memphis Grizzlies'=>'MEM',
    'Miami Heat'=>'MIA',
    'Milwaukee Bucks'=>'MIL',
    'Minnesota Timberwolves'=>'MIN',
    'New Orleans Pelicans'=>'NOP',
    'New York Knicks'=>'NYK',
    'Oklahoma City Thunder'=>'OKC',
    'Orlando Magic'=>'ORL',
    'Philadelphia 76ers'=>'PHI',
    'Phoenix Suns'=>'PHO',
    'Portland Trail Blazers'=>'POR',
    'Sacramento Kings'=>'SAC',
    'San Antonio Spurs'=>'SAS',
    'Toronto Raptors'=>'TOR',
    'Utah Jazz'=>'UTA',
    'Washington Wizards'=>'WAS'
}
NbaSeason.destroy_all
NbaTeam.destroy_all
Player.destroy_all
PlayerSeason.destroy_all

season=2018

#all this does right now is get the official nba tricode 
team_url='http://data.nba.net/10s/prod/v1/'+(season-1).to_s+'/teams.json'
team_string = RestClient.get(team_url)
team_data=JSON.parse(team_string)['league']['standard']
team_data.each do |team|
    if(team['isNBAFranchise'])
        fullname=team['fullName']
        NbaTeam.create(
            name: fullname,
            code: $team_codes[fullname],
            nba_tricode: team['tricode']
        )
    end
end

p NbaTeam.all

# http://data.nba.net/10s/prod/v1/2017/players.json

#create current season
test_season=NbaSeason.create(year: season, description: '2017-2018 NBA Season')

# response_string = RestClient.get(player_url)
# data=JSON.parse(response_string)['league']['standard'][0]
# p data

#get all players for a season-- currently it also grabs season avg's but those aren't being used as of now
def get_players(season)
    player_url='https://www.basketball-reference.com/leagues/NBA_'+season.to_s+'_per_game.html'
    mechanize=Mechanize.new
    player_page=mechanize.get(player_url)
    table_id='#per_game_stats'
    table = player_page.at(table_id)
    teams=[]
    table.search('tr').each do |tr|
        # headers = tr.search('th')

        cells = tr.search('td')
        row={}
        # get all player data
        cells.each do |cell|
            stat_name = cell.attr('data-stat')
            text = cell.text.strip
            row[stat_name]=text 
        end
        # p row
        if(row.length>0)
            team= NbaTeam.find_by(code: row['team_id'])
            if (team)
                teams.push(team.name)
                Player.create(
                    name: row['player'],
                    team_id: team.id,
                    position: row['position'],
                    out: false 
                )
            end
        end
    end
    # return stats
end


get_players(2018)

Player.all.each do |p|
    p p.name
end






