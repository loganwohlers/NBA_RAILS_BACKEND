class GameLine < ApplicationRecord
    belongs_to :player_season
    belongs_to :game
end
