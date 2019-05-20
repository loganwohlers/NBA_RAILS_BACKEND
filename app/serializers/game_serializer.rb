class GameSerializer < ActiveModel::Serializer

    attributes :id, :code, :date, :start_time, :home_pts, :away_pts
    belongs_to :season
    belongs_to :home_team, :class_name => "TeamSeason"
    belongs_to :away_team, :class_name => "TeamSeason"
    # has_many :game_lines

end