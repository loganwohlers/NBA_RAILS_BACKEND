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

#create current season
test_season=NbaSeason.create(year: season, description: '2017-2018 NBA Season')

# response_string = RestClient.get(player_url)
# data=JSON.parse(response_string)['league']['standard'][0]
# p data

#get all players for a season-- currently it also grabs season avg's but those aren't being used as of now
def get_players(season)

    test_season=NbaSeason.find_by(year: season)

    player_url='https://www.basketball-reference.com/leagues/NBA_'+season.to_s+'_per_game.html'
    mechanize=Mechanize.new
    player_page=mechanize.get(player_url)
    table_id='#per_game_stats'
    table = player_page.at(table_id)
    table.search('tr').each do |tr|
        cells = tr.search('td')
        row={}
        # get all player data
        cells.each do |cell|
            stat_name = cell.attr('data-stat')
            text = cell.text.strip
            row[stat_name]=text 
        end
        if(row.length>0)
            team= NbaTeam.find_by(code: row['team_id'])
            if (team)
                p team.id
                p test_season.id
                currPlayer=Player.create(
                    name: row['player'],
                    nba_team_id: team.id,
                    position: row['position'],
                    out: false 
                )  
                #ISSUE WAS THAT NBA_SEASON AND SEASON WERE NOT LINED UP-- MUST BE NAMED THE SAME

                # Not currently working fix tomorrow
                PlayerSeason.create!(
                    nba_season_id: test_season.id,
                    player_id: currPlayer.id,
                    mp_per_g: row['mp_per_g'], 
                    fg_per_g:  row['fg_per_g'],    
                    fga_per_g: row['fga_per_g'],     
                    fg_pct: row['fg_pct'],      
                    fg3_per_g: row['fg3_per_g'],    
                    fg3a_per_g: row['fg3a_per_g'],      
                    fg3_pct: row['fg3_pct'],      
                    efg_pct: row['efg_pct'],     
                    ft_per_g: row['ft_per_g'],      
                    fta_per_g: row['fta_per_g'],      
                    ft_pct: row['ft_pct'],     
                    orb_per_g: row['orb_per_g'],     
                    drb_per_g: row['drb_per_g'],     
                    ast_per_g: row['ast_per_g'],     
                    stl_per_g: row['stl_per_g'],     
                    blk_per_g: row['blk_per_g'],     
                    tov_per_g: row['tov_per_g'],     
                    pf_per_g: row['pf_per_g'],     
                    pts_per_g: row['pts_per_g'],     
                )  
            end
        end
    end
end

# tt=NbaTeam.first
get_players(2018)
# pl=Player.create!(
#     name: "tester",
#     team_id: tt.id,
#     position: "C",
#     out: false
# )










