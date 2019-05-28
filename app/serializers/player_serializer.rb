class PlayerSerializer < ActiveModel::Serializer
     attributes :id, :name, :position, :teams, :seasons, :player_seasons
     has_many :player_seasons
     has_many :teams, through: :player_seasons  
     has_many :seasons, through: :player_seasons 

     # def player_seasons
     #      object.get_player_summary
     #      customized=[]
     #      object.player_seasons.each do |ps|
     #           custom_hash=(ps.attributes)
     #           custom_hash['team']=ps.team.code
     #           custom_hash['year']=ps.season.year
     #           games=[]
     #           ps.game_lines.each do |g|
     #                hash2=(g.attributes)
     #                hash2['date']=g.game.date
     #                hash2['home_team']=g.game.home_team.team.code
     #                hash2['away_team']=g.game.away_team.team.code
     #                games.push(hash2)
     #           end
     #           custom_hash['games']=games

     #           customized.push(custom_hash)
     #      end
     #      customized
     # end
end


# ps.game_lines.first.game.home_team.team.code

