class Player < ApplicationRecord
    belongs_to :team
    has_many :player_seasons
end
