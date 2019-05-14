require_relative '../config/environment.rb'

# TEAM CODES global var
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



# class PlayerGame
#   attr_accessor 
#         :name, 
#         :MP,
#         :FG,
#         :FGA,
#         :FGP,
#         :TP,
#         :TPA,
#         :TPP,
#         :FT,
#         :FTA,
#         :FTP,
#         :ORB,
#         :DRB,
#         :TRB,
#         :AST,
#         :STL,
#         :BLK,
#         :TOV,
#         :PF,
#         :PTS,
#         :PM

#   GENRES=[]

#   def initialize(title)
#   end

#   def turn_page
#     puts "Flipping the page...wow, you read fast!"
#   end

#takes a game object- and finds the approproate URL and scrapes tables for box teams
def get_boxscores(game)
    mechanize=Mechanize.new
    code=game['code']
    #home/away team 3 Letter Code
    away=$team_codes[game['visitor_team_name']]
    home=$team_codes[game['home_team_name']]
    scores={}
    scores['code']=code
    scores['away_code']=away
    scores['home_code']=home

    input='https://www.basketball-reference.com/boxscores/'+ code +'.html'
    # binding.pry
    scores[away]=get_team_boxscore(away, input, mechanize)
    scores[home]=get_team_boxscore(home, input, mechanize)
    
    return scores
end

def get_team_boxscore(team, url, mechanize)
    puts team
    puts 'checking ' + team
    page=mechanize.get(url)
    table_id='#box_'+team.downcase+'_basic'
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
            # puts cell.search('data-stat')
            text = cell.text.strip
            row[stat_name]=text 
            # puts CSV.generate_line(cells)
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



def schedule_check(season)
    # months=['october', 'november', 'december', 'january', 'february', 'march', 'april']

    #just testing one month to start
    months=['october']
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
                    row['season']=season
                    #at this point the row is a 'game' so we can go grab it's boxscore
                    box=get_boxscores(row)
                    row['boxscore']=box
                    schedule.push(row)

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
        puts game['code']
        scores= get_boxscores(game)
        all_boxscores.push(scores)
    end
    return all_boxscores
end
puts 'test'

# schedule=schedule_check
shortened_schedule=schedule_check(2018)[0]

# shortened_boxscores=get_boxscores(shortened_schedule)
# puts shortened_boxscores

# opener= schedule[0]
# # BOS @ CLEVELAND 10/17
# bxs = get_boxscores(opener)
# puts JSON.pretty_generate(bxs)
# puts
# puts JSON.pretty_generate(opener)

puts JSON.pretty_generate(shortened_schedule)
puts shortened_schedule['boxscore']['home']

