class PlayerSeason < ApplicationRecord
    belongs_to :player
    belongs_to :team
    belongs_to :season
    has_many :game_lines   

    #this is breaking the front end
    has_many :games, through: :game_lines  

    def last_x_games (x)
        games= self.games.order(date: :desc).limit(x)
        games.map do |gg|
            gg.game_lines.find_by(player_season_id: self.id)
        end
    end


end