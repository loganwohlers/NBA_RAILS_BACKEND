class PlayerSerializer < ActiveModel::Serializer
     attributes :id, :name
     has_many :player_seasons
end



