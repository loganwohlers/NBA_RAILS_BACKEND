class PlayerSeason < ApplicationRecord
    belongs_to :player
    belongs_to :team_season
    has_many :game_lines


    
end