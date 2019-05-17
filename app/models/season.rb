class Season < ApplicationRecord
    has_many :games
    has_many :team_seasons
end
