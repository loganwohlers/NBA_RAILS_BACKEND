class GameSerializer < ActiveModel::Serializer

    attributes :id, :code, :date, :start_time, :home_pts, :away_pts
    belongs_to :season
    belongs_to :home_team, :class_name => "TeamSeason"
    belongs_to :away_team, :class_name => "TeamSeason"

    def season
        {year: self.object.season.year}
    end 

    def home_team
        {name: self.object.home_team.team.name,
        code: self.object.home_team.team.code }
    end

    def away_team
        {name: self.object.away_team.team.name,
        code: self.object.away_team.team.code }
    end

end