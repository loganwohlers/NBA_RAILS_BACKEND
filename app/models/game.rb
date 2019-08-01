class Game < ApplicationRecord
    belongs_to :season
    belongs_to :home_team, :class_name => "TeamSeason"
    belongs_to :away_team, :class_name => "TeamSeason"
    has_many :game_lines

    def boxscore
        self.game_lines
    end

end
