class Game < ApplicationRecord
    belongs_to :season
    belongs_to :home_team, :class_name => "TeamSeason"
    belongs_to :away_team, :class_name => "TeamSeason"
    has_many :game_lines

    def winner
        if self.home_points>self.away_points
            return self.home_team.team.name
        else
            return self.away_team.team.name
        end
    end

end
