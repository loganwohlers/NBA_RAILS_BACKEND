class GameLineSerializer < ActiveModel::Serializer

    attributes :id, :mp, :fg, :fga, :fg_pct, :fg3, :fg3a, :fg3_pct, :ft, :fta, :ft_pct, :orb, :drb, :trb, :ast, :stl, :blk, :tov, :pf, :pts, :plus_minus, :dnp

    belongs_to :game
    belongs_to :player_season

    def player_season
        {player: self.object.player_season.player.name,
        team: self.object.player_season.team_season.team.name}
    end    
   
end
