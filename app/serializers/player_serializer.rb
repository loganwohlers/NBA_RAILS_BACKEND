class PlayerSerializer < ActiveModel::Serializer
     attributes :id, :name, :position, :teams, :seasons, :player_seasons
     has_many :player_seasons
     has_many :teams, through: :player_seasons  
     has_many :seasons, through: :player_seasons 
     
#       def player_seasons
#         {name: self.object.home_team.team.name,
#         code: self.object.home_team.team.code }
#     end
end