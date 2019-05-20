class PlayerSeasonSerializer < ActiveModel::Serializer
    attributes :id, :player, :season, :team, :age, :mp_per_g, :fg_per_g, :fga_per_g, :fg_pct,
    :fg3_per_g,:fg3a_per_g, :fg3_pct, :efg_pct, :ft_per_g, :fta_per_g, :ft_pct, :orb_per_g,
    :drb_per_g, :ast_per_g, :stl_per_g, :blk_per_g, :tov_per_g, :pts_per_g
    belongs_to :player
    belongs_to :team
    belongs_to :season
#     def owner
#     {owner_id: self.object.person.id, 
#      owner_name: self.object.person.name}
#   end 

    # has_many :game_lines    
end
