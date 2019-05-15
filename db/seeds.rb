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
Season.destroy_all
Team.destroy_all
Player.destroy_all
PlayerSeason.destroy_all
Game.destroy_all
GameLine.destroy_all



#all this does right now is get the official nba tricode 
#they don't really need a season but just in-case expansion teams added
# def get_teams(season)
#     team_url='http://data.nba.net/10s/prod/v1/'+(season-1).to_s+'/teams.json'
#     team_string = RestClient.get(team_url)
#     team_data=JSON.parse(team_string)['league']['standard']
#     team_data.each do |team|
#         if(team['isNBAFranchise'])
#             fullname=team['fullName']
#             Team.create(
#                 name: fullname,
#                 code: $team_codes[fullname],
#                 nba_tricode: team['tricode']
#             )
#         end
#     end
# end

def get_teams_2
    $team_codes.each do |k,v|
        Team.create(
                name: k,
                code: v,
                nba_tricode: v
            )
    end
end




#get all players for a season-- and their season avgs
def get_players(season)
    test_season=Season.find_by(year: season)
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
            team= Team.find_by(code: row['team_id'])
            if (team)
                currPlayer=Player.find_or_create_by(
                    name: row['player'],
                    team_id: team.id,
                    position: row['position'],
                    out: false 
                    ) 
                    
                    #ISSUE WAS THAT NBA_SEASON AND SEASON WERE NOT LINED UP-- MUST BE NAMED THE SAME

                PlayerSeason.create!(
                    season_id: test_season.id,
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

    test_season=Season.find_by(year: season)

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
                    home_team=Team.find_by(name: row['home_team_name'])
                    away_team=Team.find_by(name: row['visitor_team_name'])
                    
                    Game.create(
                        code: row['code'],
                        date: row['date_game'],
                        start_time: row['game_start_time'],
                        season_id: test_season.id,
                        home_team_id: home_team.id,
                        away_team_id: away_team.id,
                        home_pts: row['home_pts'],
                        away_pts: row['visitor_pts'] 
                    )
                    

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
    team=Team.find(game.home_team_id)
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

    #could create the Line here--loop thru mapped and make a game line w/ playerseason/game/box
    mapped.each do |gameline|
        player=Player.find_by(name: gameline[0])
        ps=PlayerSeason.find_by(player_id: player.id)
        p player.name
   
        p gameline[1]['plus_minus']
    
        if !gameline[1]['mp']
            GameLine.create!(
                game_id: game.id,
                player_season_id: ps.id,
                dnp: true
            )       
        else
            GameLine.create!(
                game_id: game.id,
                player_season_id: ps.id,
                mp: gameline[1]['mp'], 
                fg:  gameline[1]['fg'],    
                fga: gameline[1]['fga'],     
                fg_pct: gameline[1]['fg_pct'],      
                fg3: gameline[1]['fg3'],    
                fg3a: gameline[1]['fg3a'],      
                fg3_pct: gameline[1]['fg3_pct'],      
                ft: gameline[1]['ft'],      
                fta: gameline[1]['fta'],      
                ft_pct: gameline[1]['ft_pct'],     
                orb: gameline[1]['orb'],     
                drb: gameline[1]['drb'],     
                trb: gameline[1]['trb'],     
                ast: gameline[1]['ast'],     
                stl: gameline[1]['stl'],     
                blk: gameline[1]['blk'],     
                tov: gameline[1]['tov'],     
                pf: gameline[1]['pf'],     
                pts: gameline[1]['pts'], 
                plus_minus: gameline[1]['plus_minus'], 
                dnp: false    
                )
        
                
        end
    end  
        return mapped
end
        
        
        
        ##################################
        
    season=2018

    #create current season
    test_season=Season.create(year: season, description: '2017-2018 NBA Season')

    #seed the teams for a given season
    # get_teams(test_season.year)
    get_teams_2
    
    #get all theplayers/player seasons
    get_players(test_season.year)

    team1=Team.first
    team2=Team.last

    test_schedule=schedule_check(test_season.year)

    opener=Game.first
    get_team_boxscore(opener)
    p GameLine.all
