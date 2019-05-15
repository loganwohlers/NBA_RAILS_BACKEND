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
NbaGame.destroy_all



#all this does right now is get the official nba tricode 
#they don't really need a season but just in-case expansion teams added
# def get_teams(season)
#     team_url='http://data.nba.net/10s/prod/v1/'+(season-1).to_s+'/teams.json'
#     team_string = RestClient.get(team_url)
#     team_data=JSON.parse(team_string)['league']['standard']
#     team_data.each do |team|
#         if(team['isNBAFranchise'])
#             fullname=team['fullName']
#             NbaTeam.create(
#                 name: fullname,
#                 code: $team_codes[fullname],
#                 nba_tricode: team['tricode']
#             )
#         end
#     end
# end

def get_teams_2
    $team_codes.each do |k,v|
        NbaTeam.create(
                name: k,
                code: v,
                nba_tricode: v
            )
    end
end




#get all players for a season-- and their season avgs
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
                currPlayer=Player.find_or_create_by(
                    name: row['player'],
                    nba_team_id: team.id,
                    position: row['position'],
                    out: false 
                    ) 
                    
                    #ISSUE WAS THAT NBA_SEASON AND SEASON WERE NOT LINED UP-- MUST BE NAMED THE SAME

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

# def get_boxscores(game)
#     mechanize=Mechanize.new
#     # code=game['code']
#     #home/away team 3 Letter Code
#     away=$team_codes[game['visitor_team_name']]
#     home=$team_codes[game['home_team_name']]
#     scores={}
#     # scores['code']=code
#     scores['away_code']=away
#     scores['home_code']=home

#     input='https://www.basketball-reference.com/boxscores/'+ code +'.html'

#     scores[away]=get_team_boxscore(away, input, mechanize, game)
#     scores[home]=get_team_boxscore(home, input, mechanize, game)
    
#     return scores
# end





def schedule_check(season)
    # months=['october', 'november', 'december', 'january', 'february', 'march', 'april']
    #just testing one month to start
    months=['october']

    test_season=NbaSeason.find_by(year: season)

    schedule=[]
    mechanize=Mechanize.new
    months.each do |month|
            input='https://www.basketball-reference.com/leagues/NBA_'+ season.to_s + '_games-' + month + '.html' 
            page=mechanize.get(input)
            schedule_table=page.at('#schedule')
            
            #this is used to check for the second blank row in the table that only
            #shows up IN April-- signals start of playoffs 
            count=0;
            schedule_table.search('tr').each do |tr|
                row={}
                th=tr.search('th')
                if(th.attr('csk'))
                    row['code']=th.attr('csk').value
                    val=th.attr('data-stat').value
                    row[val]=th.text.strip
                end

                cells = tr.search('td')
                cells.each do |cell|
                    # if(!cell.attr('data-stat')=="box_score_text")
                        stat_name = cell.attr('data-stat')
                        text = cell.text.strip
                        row[stat_name]=text 
                    # end
                end
                if (!row.blank?)
                    home_team=NbaTeam.find_by(name: row['home_team_name'])
                    away_team=NbaTeam.find_by(name: row['visitor_team_name'])
                    
                    NbaGame.create(
                        code: row['code'],
                        date: row['date_game'],
                        start_time: row['game_start_time'],
                        nba_season_id: test_season.id,
                        home_team_id: home_team.id,
                        away_team_id: away_team.id,
                        home_pts: row['home_pts'],
                        away_pts: row['visitor_pts'] 
                    )
                    # puts row

                    #  {"code"=>"201710310MIL", "date_game"=>"Tue, Oct 31, 2017", "game_start_time"=>"8:00p", "visitor_team_name"=>"Oklahoma City Thunder", "visitor_pts"=>"110", "home_team_name"=>"Milwaukee Bucks", "home_pts"=>"91", "box_score_text"=>"Box Score", "overtimes"=>"", "attendance"=>"16,713", "game_remarks"=>""}
                    # row['season']=season
                    # #at this point the row is a 'game' so we can go grab it's boxscore
                    # box=get_boxscores(row)
                    # row['boxscore']=box
                    # schedule.push(row)

                     # def change
                        # create_table :nba_games do |t|
                        #   t.string :code
                        #   t.string :date
                        #   t.string :start_time
                        #   t.references :nba_season
                        #   t.integer :home_team_id
                        #   t.integer :away_team_id
                        #   t.integer :home_pts
                        #   t.integer :away_pts

                        #   t.timestamps
                        # end

                    #here is where we would get the boxscore in the seeds
                else
                    count+=1
                    if(count==2)
                        #we break here when we hit the playoffs
                        return schedule
                    end
                end 
            end
            return schedule
        end
end


def all_boxscores(games)
    all_boxscores=[]
    games.each do |game|
        scores= get_boxscores(game)
        all_boxscores.push(scores)
    end
    return all_boxscores
end


def get_team_boxscore(game)  
    team=NbaTeam.find(game.home_team_id)
    puts team.name

    url="https://www.basketball-reference.com/boxscores/#{game.code}.html"
    p url
    #  THIS IS THE TEAM CODE
    mechanize=Mechanize.new
    page=mechanize.get(url)
    table_id='#box_'+team.code.downcase+'_basic'
    table = page.at(table_id)
    players=[]
    stats=[]
    table.search('tr').each do |tr|
        headers = tr.search('th')
        headers.each do |hh|
            text = hh.text.strip
            # //getting all player names
            if(
                (text!="Basic Box Score Stats") && (text!="Starters") &&
                (text!="Reserves") &&
                (text!="Team Totals") &&
                (text.length > 5)
            )
                players.push(text)
            end
        end
        cells = tr.search('td')
        row={}
        # get all player data
        cells.each do |cell|
            stat_name = cell.attr('data-stat')
            text = cell.text.strip
            row[stat_name]=text 
        end
        # filter empty rows
        if(row.length>0)
            stats.push(row)
        end
    end
    # remove team totals from stats
    stats.pop()
    # map players to their stats
    mapped = {}
    for x in 0..players.length-1
        mapped[players[x]]=stats[x]
    end

    #could create the Line here
    p mapped
    return mapped
end



##################################

    season=2018

    #create current season
    test_season=NbaSeason.create(year: season, description: '2017-2018 NBA Season')

    #seed the teams for a given season
    # get_teams(test_season.year)
    get_teams_2
    
    #get all theplayers/player seasons
    # get_players(test_season.year)

    team1=NbaTeam.first
    team2=NbaTeam.last

    test_schedule=schedule_check(test_season.year)

    opener=NbaGame.first
    get_team_boxscore(opener)

#    <NbaGame id: 327, code: "201710170CLE", date: "Tue, Oct 17, 2017", start_time: "8:01p", home_team_id: 756, away_team_id: 752, home_pts: 102, away_pts: 99, created_at: "2019-05-15 17:45:15", updated_at: "2019-05-15 17:45:15", nba_season_id: 26>
# 2.6.1 :002 > exit

 

   


    # schedule_check(test_season.year)


#     {
#   "code": "201710170CLE",
#   "date_game": "Tue, Oct 17, 2017",
#   "game_start_time": "8:01p",
#   "visitor_team_name": "Boston Celtics",
#   "visitor_pts": "99",
#   "home_team_name": "Cleveland Cavaliers",
#   "home_pts": "102",
#   "box_score_text": "Box Score",
#   "overtimes": "",
#   "attendance": "20,562",
#   "game_remarks": "",
#   "season": 2018,
#   "boxscore": {
#     "code": "201710170CLE",
#     "away_code": "BOS",
#     "home_code": "CLE",
#     "BOS": {
#       "Jaylen Brown": {
#         "mp": "39:36",
#         "fg": "11",
#         "fga": "23",
#         "fg_pct": ".478",
#         "fg3": "2",
#         "fg3a": "9",
#         "fg3_pct": ".222",
#         "ft": "1",
#         "fta": "2",
#         "ft_pct": ".500",
#         "orb": "1",
#         "drb": "5",
#         "trb": "6",
#         "ast": "0",
#         "stl": "2",
#         "blk": "0",
#         "tov": "3",
#         "pf": "5",
#         "pts": "25",
#         "plus_minus": "-5"
#       },
#       "Kyrie Irving": {
#         "mp": "39:21",
#         "fg": "8",
#         "fga": "17",
#         "fg_pct": ".471",
#         "fg3": "4",
#         "fg3a": "9",
#         "fg3_pct": ".444",
#         "ft": "2",
#         "fta": "2",
#         "ft_pct": "1.000",
#         "orb": "2",
#         "drb": "2",
#         "trb": "4",
#         "ast": "10",
#         "stl": "3",
#         "blk": "0",
#         "tov": "2",
#         "pf": "4",
#         "pts": "22",
#         "plus_minus": "-1"
#       },
#       "Jayson Tatum": {
#         "mp": "36:32",
#         "fg": "5",
#         "fga": "12",
#         "fg_pct": ".417",
#         "fg3": "1",
#         "fg3a": "2",
#         "fg3_pct": ".500",
#         "ft": "3",
#         "fta": "3",
#         "ft_pct": "1.000",
#         "orb": "4",
#         "drb": "6",
#         "trb": "10",
#         "ast": "3",
#         "stl": "0",
#         "blk": "0",
#         "tov": "1",
#         "pf": "4",
#         "pts": "14",
#         "plus_minus": "+6"
#       },
#       "Al Horford": {
#         "mp": "32:07",
#         "fg": "2",
#         "fga": "7",
#         "fg_pct": ".286",
#         "fg3": "0",
#         "fg3a": "2",
#         "fg3_pct": ".000",
#         "ft": "5",
#         "fta": "7",
#         "ft_pct": ".714",
#         "orb": "0",
#         "drb": "7",
#         "trb": "7",
#         "ast": "5",
#         "stl": "0",
#         "blk": "1",
#         "tov": "0",
#         "pf": "2",
#         "pts": "9",
#         "plus_minus": "+8"
#       },
#       "Gordon Hayward": {
#         "mp": "5:15",
#         "fg": "1",
#         "fga": "2",
#         "fg_pct": ".500",
#         "fg3": "0",
#         "fg3a": "1",
#         "fg3_pct": ".000",
#         "ft": "0",
#         "fta": "0",
#         "ft_pct": "",
#         "orb": "0",
#         "drb": "1",
#         "trb": "1",
#         "ast": "0",
#         "stl": "0",
#         "blk": "0",
#         "tov": "0",
#         "pf": "1",
#         "pts": "2",
#         "plus_minus": "+3"
#       },
#       "Marcus Smart": {
#         "mp": "35:03",
#         "fg": "5",
#         "fga": "16",
#         "fg_pct": ".313",
#         "fg3": "0",
#         "fg3a": "4",
#         "fg3_pct": ".000",
#         "ft": "2",
#         "fta": "3",
#         "ft_pct": ".667",
#         "orb": "0",
#         "drb": "9",
#         "trb": "9",
#         "ast": "3",
#         "stl": "2",
#         "blk": "2",
#         "tov": "2",
#         "pf": "2",
#         "pts": "12",
#         "plus_minus": "-8"
#       },
#       "Terry Rozier": {
#         "mp": "19:32",
#         "fg": "2",
#         "fga": "6",
#         "fg_pct": ".333",
#         "fg3": "1",
#         "fg3a": "3",
#         "fg3_pct": ".333",
#         "ft": "4",
#         "fta": "4",
#         "ft_pct": "1.000",
#         "orb": "0",
#         "drb": "3",
#         "trb": "3",
#         "ast": "2",
#         "stl": "4",
#         "blk": "0",
#         "tov": "0",
#         "pf": "0",
#         "pts": "9",
#         "plus_minus": "+4"
#       },
#       "Aron Baynes": {
#         "mp": "19:06",
#         "fg": "2",
#         "fga": "2",
#         "fg_pct": "1.000",
#         "fg3": "0",
#         "fg3a": "0",
#         "fg3_pct": "",
#         "ft": "2",
#         "fta": "4",
#         "ft_pct": ".500",
#         "orb": "2",
#         "drb": "3",
#         "trb": "5",
#         "ast": "1",
#         "stl": "0",
#         "blk": "1",
#         "tov": "2",
#         "pf": "5",
#         "pts": "6",
#         "plus_minus": "-14"
#       },
#       "Semi Ojeleye": {
#         "mp": "8:39",
#         "fg": "0",
#         "fga": "2",
#         "fg_pct": ".000",
#         "fg3": "0",
#         "fg3a": "1",
#         "fg3_pct": ".000",
#         "ft": "0",
#         "fta": "0",
#         "ft_pct": "",
#         "orb": "0",
#         "drb": "0",
#         "trb": "0",
#         "ast": "0",
#         "stl": "0",
#         "blk": "0",
#         "tov": "0",
#         "pf": "1",
#         "pts": "0",
#         "plus_minus": "-10"
#       },
#       "Shane Larkin": {
#         "mp": "4:49",
#         "fg": "0",
#         "fga": "1",
#         "fg_pct": ".000",
#         "fg3": "0",
#         "fg3a": "1",
#         "fg3_pct": ".000",
#         "ft": "0",
#         "fta": "0",
#         "ft_pct": "",
#         "orb": "0",
#         "drb": "1",
#         "trb": "1",
#         "ast": "0",
#         "stl": "0",
#         "blk": "0",
#         "tov": "0",
#         "pf": "0",
#         "pts": "0",
#         "plus_minus": "+2"
#       },
#       "Abdel Nader": {
#         "reason": "Did Not Play"
#       },
#       "Daniel Theis": {
#         "reason": "Did Not Play"
#       }
#     },
#     "CLE": {
#       "LeBron James": {
#         "mp": "41:12",
#         "fg": "12",
#         "fga": "19",
#         "fg_pct": ".632",
#         "fg3": "1",
#         "fg3a": "5",
#         "fg3_pct": ".200",
#         "ft": "4",
#         "fta": "4",
#         "ft_pct": "1.000",
#         "orb": "1",
#         "drb": "15",
#         "trb": "16",
#         "ast": "9",
#         "stl": "0",
#         "blk": "2",
#         "tov": "4",
#         "pf": "3",
#         "pts": "29",
#         "plus_minus": "+2"
#       },
#       "Jae Crowder": {
#         "mp": "34:44",
#         "fg": "3",
#         "fga": "10",
#         "fg_pct": ".300",
#         "fg3": "1",
#         "fg3a": "5",
#         "fg3_pct": ".200",
#         "ft": "4",
#         "fta": "4",
#         "ft_pct": "1.000",
#         "orb": "1",
#         "drb": "4",
#         "trb": "5",
#         "ast": "2",
#         "stl": "2",
#         "blk": "0",
#         "tov": "1",
#         "pf": "2",
#         "pts": "11",
#         "plus_minus": "+7"
#       },
#       "Derrick Rose": {
#         "mp": "31:15",
#         "fg": "5",
#         "fga": "14",
#         "fg_pct": ".357",
#         "fg3": "1",
#         "fg3a": "3",
#         "fg3_pct": ".333",
#         "ft": "3",
#         "fta": "4",
#         "ft_pct": ".750",
#         "orb": "1",
#         "drb": "3",
#         "trb": "4",
#         "ast": "2",
#         "stl": "0",
#         "blk": "0",
#         "tov": "2",
#         "pf": "2",
#         "pts": "14",
#         "plus_minus": "-7"
#       },
#       "Dwyane Wade": {
#         "mp": "28:30",
#         "fg": "3",
#         "fga": "10",
#         "fg_pct": ".300",
#         "fg3": "0",
#         "fg3a": "1",
#         "fg3_pct": ".000",
#         "ft": "2",
#         "fta": "2",
#         "ft_pct": "1.000",
#         "orb": "1",
#         "drb": "1",
#         "trb": "2",
#         "ast": "3",
#         "stl": "0",
#         "blk": "2",
#         "tov": "4",
#         "pf": "1",
#         "pts": "8",
#         "plus_minus": "0"
#       },
#       "Kevin Love": {
#         "mp": "28:24",
#         "fg": "4",
#         "fga": "9",
#         "fg_pct": ".444",
#         "fg3": "1",
#         "fg3a": "4",
#         "fg3_pct": ".250",
#         "ft": "6",
#         "fta": "7",
#         "ft_pct": ".857",
#         "orb": "3",
#         "drb": "8",
#         "trb": "11",
#         "ast": "0",
#         "stl": "0",
#         "blk": "0",
#         "tov": "2",
#         "pf": "2",
#         "pts": "15",
#         "plus_minus": "+1"
#       },
#       "J.R. Smith": {
#         "mp": "21:55",
#         "fg": "4",
#         "fga": "7",
#         "fg_pct": ".571",
#         "fg3": "1",
#         "fg3a": "3",
#         "fg3_pct": ".333",
#         "ft": "1",
#         "fta": "1",
#         "ft_pct": "1.000",
#         "orb": "0",
#         "drb": "4",
#         "trb": "4",
#         "ast": "1",
#         "stl": "0",
#         "blk": "0",
#         "tov": "0",
#         "pf": "4",
#         "pts": "10",
#         "plus_minus": "+7"
#       },
#       "Tristan Thompson": {
#         "mp": "19:36",
#         "fg": "2",
#         "fga": "3",
#         "fg_pct": ".667",
#         "fg3": "0",
#         "fg3a": "0",
#         "fg3_pct": "",
#         "ft": "1",
#         "fta": "3",
#         "ft_pct": ".333",
#         "orb": "1",
#         "drb": "5",
#         "trb": "6",
#         "ast": "2",
#         "stl": "0",
#         "blk": "0",
#         "tov": "2",
#         "pf": "3",
#         "pts": "5",
#         "plus_minus": "+2"
#       },
#       "Jeff Green": {
#         "mp": "14:14",
#         "fg": "3",
#         "fga": "8",
#         "fg_pct": ".375",
#         "fg3": "0",
#         "fg3a": "1",
#         "fg3_pct": ".000",
#         "ft": "0",
#         "fta": "0",
#         "ft_pct": "",
#         "orb": "0",
#         "drb": "0",
#         "trb": "0",
#         "ast": "0",
#         "stl": "0",
#         "blk": "0",
#         "tov": "1",
#         "pf": "3",
#         "pts": "6",
#         "plus_minus": "-2"
#       },
#       "Iman Shumpert": {
#         "mp": "12:51",
#         "fg": "2",
#         "fga": "3",
#         "fg_pct": ".667",
#         "fg3": "0",
#         "fg3a": "0",
#         "fg3_pct": "",
#         "ft": "0",
#         "fta": "0",
#         "ft_pct": "",
#         "orb": "1",
#         "drb": "1",
#         "trb": "2",
#         "ast": "0",
#         "stl": "1",
#         "blk": "0",
#         "tov": "1",
#         "pf": "3",
#         "pts": "4",
#         "plus_minus": "+6"
#       },
#       "Kyle Korver": {
#         "mp": "7:19",
#         "fg": "0",
#         "fga": "0",
#         "fg_pct": "",
#         "fg3": "0",
#         "fg3a": "0",
#         "fg3_pct": "",
#         "ft": "0",
#         "fta": "0",
#         "ft_pct": "",
#         "orb": "0",
#         "drb": "0",
#         "trb": "0",
#         "ast": "0",
#         "stl": "0",
#         "blk": "0",
#         "tov": "0",
#         "pf": "2",
#         "pts": "0",
#         "plus_minus": "-1"
#       },
#       "Cedi Osman": {
#         "reason": "Did Not Play"
#       },
#       "Jose Calderon": {
#         "reason": "Did Not Play"
#       },
#       "Channing Frye": {
#         "reason": "Did Not Play"
#       }
#     }
#   }
# }
    
    
    
    
    
    
    




