class NbaTeam < ApplicationRecord
    has_many :players
    has_many :home_games, :class_name => "NbaGame", :foreign_key => 'home_team_id'
    has_many :away_games, :class_name => "NbaGame", :foreign_key => 'away_team_id'
end
