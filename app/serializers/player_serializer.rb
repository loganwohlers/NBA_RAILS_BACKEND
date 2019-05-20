class PlayerSerializer < ActiveModel::Serializer
     attributes :id, :name, :position
     has_many :player_seasons

end