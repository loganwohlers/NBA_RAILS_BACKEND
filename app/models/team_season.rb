class TeamSeason < ApplicationRecord
    has_many :player_seasons
    belongs_to :team
    belongs_to :season
    has_many :home_games, :class_name => "Game", :foreign_key => 'home_team_id'
    has_many :away_games, :class_name => "Game", :foreign_key => 'away_team_id'
end
