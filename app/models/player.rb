class Player < ApplicationRecord
    has_many :player_seasons

    def get_player_season(yr)
        return self.player_seasons.joins(:season).where(seasons: {year: yr}).take
    end

    def get_game_lines(yr)
        self.get_player_season(yr).game_lines
    end

    def get_all_teams
        teams=[]
        self.player_seasons.each do |season|
            teams.push("#{season.team.name}: #{yr}")
        end
        return teams 
    end
end
