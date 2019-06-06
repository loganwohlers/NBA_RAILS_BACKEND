class Season < ApplicationRecord
    has_many :games
    has_many :team_seasons
    has_many :player_seasons, through: :team_seasons
    



end
