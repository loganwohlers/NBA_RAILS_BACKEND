class TeamSeason < ApplicationRecord
    has_many :player_seasons
    belongs_to :team
    belongs_to :season
end
