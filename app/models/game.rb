class Game < ApplicationRecord
    belongs_to :season
    has_one :home_team, :class_name => "Team"
    has_one :away_team, :class_name => "Team"
    has_many :game_lines

end
