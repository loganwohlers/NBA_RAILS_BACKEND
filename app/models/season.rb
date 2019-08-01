class Season < ApplicationRecord
    has_many :games
    has_many :team_seasons
    has_many :player_seasons, through: :team_seasons

    #selects all relavant player seasons(only where the player season age attribute exists)
    def filter_player_seasons
        self.player_seasons.select{|ps| ps.age}
    end
    



end
