class Player < ApplicationRecord
    has_many :player_seasons
    has_many :teams, through: :player_seasons  
    has_many :seasons, through: :player_seasons  
    # has_many :game_lines, through: :player_seasons  

    #hacky way around serializer issues
    def get_player_summary
        summary_hash=self.attributes
        summary_hash['team_seasons']=self.team_seasons
        customized=[]
          self.player_seasons.each do |ps|
               custom_hash=(ps.attributes)
               custom_hash['team']=ps.team_season.team.code
               custom_hash['year']=ps.team_season.season.year
               games=[]
               ps.game_lines.each do |g|
                    hash2=(g.attributes)
                    hash2['date']=g.game.date
                    hash2['home_team']=g.game.home_team.team.code
                    hash2['away_team']=g.game.away_team.team.code
                    games.push(hash2)
               end
               custom_hash['games']=games

               customized.push(custom_hash)
          end
        summary_hash['player_seasons']=customized
        return summary_hash
    end



    def get_player_season(yr)
        return self.player_seasons.joins(:season).where(seasons: {year: yr}).take
    end

    def get_game_lines(yr)
        self.get_player_season(yr).game_lines
    end

    def get_all_positions
        positions=[]
        self.player_seasons.each do |season|
            positions.push("#{season.position}")
        end
        return positions.uniq 
    end

    def get_all_teams
        teams=[]
        self.player_seasons.each do |season|
            teams.push("#{season.team.name}: #{yr}")
        end
        return teams
    end
end
