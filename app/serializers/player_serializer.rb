class PlayerSerializer < ActiveModel::Serializer
     attributes :id, :name, :position, :teams, :seasons, :player_seasons
     has_many :player_seasons
     has_many :teams, through: :player_seasons  
     has_many :seasons, through: :player_seasons 

     def player_seasons
          customized=[]
          object.player_seasons.each do |ps|
               custom_hash=(ps.attributes)
               custom_hash['team']=ps.team.code
               custom_hash['year']=ps.season.year
               customized.push(custom_hash)
          end
          customized
     end

end