class PlayerSerializer < ActiveModel::Serializer
     attributes :id, :name, :position
     has_many :player_seasons

#      def player_seasons
#         {name: self.object.home_team.team.name,
#         code: self.object.home_team.team.code }
#     end
          
end