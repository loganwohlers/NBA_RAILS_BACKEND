class PlayerSeason < ApplicationRecord
    belongs_to :player
    belongs_to :team
    belongs_to :season
    has_many :game_lines   
    has_many :games, through: :game_lines  
    
    def get_last_x_game_lines (x)
        return self.games
    end


end