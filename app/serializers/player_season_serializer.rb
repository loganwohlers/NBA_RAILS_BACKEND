class PlayerSeasonSerializer < ActiveModel::Serializer
    attributes :id, :player, :season, :team
    belongs_to :player
    belongs_to :team
    belongs_to :season
    
    # has_many :game_lines    
end