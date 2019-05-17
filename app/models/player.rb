class Player < ApplicationRecord
    has_many :player_seasons

    def get_season_averages(season)
        p self.player_seasons.first.team_season.team
        return self.player_seasons
    end

    def get_all_teams
        teams=[]
        self.player_seasons.each do |season|
            team=season.team_season.team.name
            yr=season.team_season.season.year
            teams.push("#{team}: #{yr}")
        end
        return teams 
    end
end
