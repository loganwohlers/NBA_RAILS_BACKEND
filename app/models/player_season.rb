class PlayerSeason < ApplicationRecord
    belongs_to :player
    belongs_to :team
    belongs_to :season
    has_many :game_lines    
end