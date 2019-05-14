# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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


test_season=NbaSeason.create(year: 2018, description: '2017-2018 NBA Season')

