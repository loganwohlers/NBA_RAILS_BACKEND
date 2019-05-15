class PlayerSeason < ApplicationRecord
    belongs_to :player
    belongs_to :nba_season
end