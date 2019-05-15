class NbaGame < ApplicationRecord
    belongs_to :nba_season
    has_one :home_team, :class_name => "NbaTeam"
    has_one :away_team, :class_name => "NbaTeam"
    has_many :game_lines

end
