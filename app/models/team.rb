class Team < ApplicationRecord
    has_many :team_seaons
    has_many :player_seaons
    
end
