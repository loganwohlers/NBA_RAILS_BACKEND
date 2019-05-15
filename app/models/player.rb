class Player < ApplicationRecord
    belongs_to :nba_team, optional:true
    has_many :player_seasons
end
