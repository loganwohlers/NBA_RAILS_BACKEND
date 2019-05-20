class PlayerSeasonSerializer < ActiveModel::Serializer
    attributes :id, :player_id, :age, :season_id, :team_id
    belongs_to :player
    belongs_to :team
    belongs_to :season
    has_many :game_lines    
end