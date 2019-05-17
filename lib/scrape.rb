require_relative '../config/environment.rb'
require_relative 'team_codes'

def seed_season(season)
    get_teams
    get_team_seasons(season)
    get_players(season)
    get_schedule(season)
    get_season_stats(season.games)

end
#use team codes to creat all 30 teams- and creates team seasons
def get_teams
    $team_codes.each do |k,v|
        Team.create(
            name: k,
            code: v,
            nba_tricode: v
        )
    end
end

def get_team_seasons (season)
    Team.all.each do |team|
        TeamSeason.create(
            team_id: team.id,
            season_id: season.id
        )
    end
end

#get all players for a season-- and their season avgs
#use them to create player seasons/new players
def get_players(season)
    mechanize=Mechanize.new
    player_url='https://www.basketball-reference.com/leagues/NBA_'+season.year.to_s+'_per_game.html'
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
                    position: row['pos'],
                    out: false 
                ) 
                PlayerSeason.create!(
                    team_id: team.id,
                    player_id: currPlayer.id,
                    season_id: season.id,
                    age: row['age'],
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

#assocation is wwrongeird here so we have to go find the team instance first
def get_season_stats(games)
    mechanize=Mechanize.new
    games.each do |game|
        puts game.code
        get_team_boxscore(game, game.home_team.team, mechanize)
        get_team_boxscore(game, game.away_team.team, mechanize)
    end
end

def get_team_boxscore(game, team, mechanize) 
    mapped_stats=get_game_box(game, team , mechanize)
    season=game.season
    mapped_stats.each do |gameline|
        make_gameline(season, team, game, gameline)     
    end  
end

#could all be find or create by?
def make_gameline(season, team, game, gameline)
    player=Player.find_or_create_by(name: gameline[0])
  
        ps=PlayerSeason.find_or_create_by(
            player_id: player.id,
            team_id: team.id,
            season_id: season.id
        )
    #this checks for dnp rows
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

def get_game_box(game, team, mechanize)
        url="https://www.basketball-reference.com/boxscores/#{game.code}.html"
        page=mechanize.get(url)
        table_id='#box_'+team.code.downcase+'_basic'
        table = page.at(table_id)
        players=[]
        stats=[]
        table.search('tr').each do |tr|
            headers = tr.search('th')
            # //getting all player names
            headers.each do |hh|
                text = hh.text.strip
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
    return mapped
end


# just testing one month to start
# months=['october']
def get_schedule(season)
    months=['october', 'november', 'december', 'january', 'february', 'march', 'april']
    schedule=[]
    mechanize=Mechanize.new
   
    months.each do |month|
        p month
        input='https://www.basketball-reference.com/leagues/NBA_'+ season.year.to_s + '_games-' + month + '.html' 
        page=mechanize.get(input)
        schedule_table=page.at('#schedule')
                
        #this is used to check for the second blank row in the table that only
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
                stat_name = cell.attr('data-stat')
                text = cell.text.strip
                row[stat_name]=text 
            end

            if (!row.blank?)
                home_team=Team.find_by(name: row['home_team_name'])
                away_team=Team.find_by(name: row['visitor_team_name'])

                home_season=TeamSeason.find_by(season_id: season.id, team_id: home_team.id)
                away_season=TeamSeason.find_by(season_id: season.id, team_id: away_team.id) 
                Game.create(
                    code: row['code'],

                    #shave team part(last 4 chars) of of game code for stringified date
                    date: row['code'][0...-5]
                    start_time: row['game_start_time'],
                    home_pts: row['home_pts'],
                    away_pts: row['visitor_pts'], 
                    season_id: season.id,
                    home_team_id: home_season.id,
                    away_team_id: away_season.id
                )
                    
                #we break here when we hit the playoffs- could add back
                else
                    count+=1
                    if(count==2)
                        return schedule
                    end
                end 
            end
        end
    return schedule
end

###########################
# BELOW ARE SCRAPING METHODS NOT USED FOR RAILS DB

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


# def all_boxscores(games)
#     all_boxscores=[]
#     games.each do |game|
#         scores= get_boxscores(game)
#         all_boxscores.push(scores)
#     end
#     return all_boxscores
# end

#this one is 50/50 rails vs normal data 

# def get_team_boxscore(game)  
#     team=Team.find(game.home_team_id)
#     puts team.name

#     url="https://www.basketball-reference.com/boxscores/#{game.code}.html"
#     p url
#     #  THIS IS THE TEAM CODE
#     mechanize=Mechanize.new
#     page=mechanize.get(url)
#     table_id='#box_'+team.code.downcase+'_basic'
#     table = page.at(table_id)
#     players=[]
#     stats=[]
#     table.search('tr').each do |tr|
#         headers = tr.search('th')
#         headers.each do |hh|
#             text = hh.text.strip
#             # //getting all player names
#             if(
#                 (text!="Basic Box Score Stats") && (text!="Starters") &&
#                 (text!="Reserves") &&
#                 (text!="Team Totals") &&
#                 (text.length > 5)
#             )
#                 players.push(text)
#             end
#         end
#         cells = tr.search('td')
#         row={}
#         # get all player data
#         cells.each do |cell|
#             stat_name = cell.attr('data-stat')
#             text = cell.text.strip
#             row[stat_name]=text 
#         end
#         # filter empty rows
#         if(row.length>0)
#             stats.push(row)
#         end
#     end
#     # remove team totals from stats
#     stats.pop()
#     # map players to their stats
#     mapped = {}
#     for x in 0..players.length-1
#         mapped[players[x]]=stats[x]
#     end

#     # going through our map of player/boxscore and creating a gameline
#     mapped.each do |gameline|
#         player=Player.find_by(name: gameline[0])
#         ps=PlayerSeason.find_by(player_id: player.id)
   
#         if !gameline[1]['mp']
#             GameLine.create!(
#                 game_id: game.id,
#                 player_season_id: ps.id,
#                 dnp: true
#             )       
#         else
#             GameLine.create!(
#                 game_id: game.id,
#                 player_season_id: ps.id,
#                 mp: gameline[1]['mp'], 
#                 fg:  gameline[1]['fg'],    
#                 fga: gameline[1]['fga'],     
#                 fg_pct: gameline[1]['fg_pct'],      
#                 fg3: gameline[1]['fg3'],    
#                 fg3a: gameline[1]['fg3a'],      
#                 fg3_pct: gameline[1]['fg3_pct'],      
#                 ft: gameline[1]['ft'],      
#                 fta: gameline[1]['fta'],      
#                 ft_pct: gameline[1]['ft_pct'],     
#                 orb: gameline[1]['orb'],     
#                 drb: gameline[1]['drb'],     
#                 trb: gameline[1]['trb'],     
#                 ast: gameline[1]['ast'],     
#                 stl: gameline[1]['stl'],     
#                 blk: gameline[1]['blk'],     
#                 tov: gameline[1]['tov'],     
#                 pf: gameline[1]['pf'],     
#                 pts: gameline[1]['pts'], 
#                 plus_minus: gameline[1]['plus_minus'], 
#                 dnp: false    
#                 )        
#         end
#     end  
#         return mapped
# end