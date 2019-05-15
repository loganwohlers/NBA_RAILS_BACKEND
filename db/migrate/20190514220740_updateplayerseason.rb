class Updateplayerseason < ActiveRecord::Migration[5.2]
  def change
    add_column :player_seasons, :age, :string
    add_column :player_seasons, :mp_per_g, :string
    add_column :player_seasons, :fg_per_g, :string
    add_column :player_seasons, :fga_per_g, :string
    add_column :player_seasons, :fg_pct, :string
    add_column :player_seasons, :fg3_per_g, :string
    add_column :player_seasons, :fg3a_per_g, :string
    add_column :player_seasons, :fg3_pct, :string
    add_column :player_seasons, :efg_pct, :string
    add_column :player_seasons, :ft_per_g, :string
    add_column :player_seasons, :fta_per_g, :string
    add_column :player_seasons, :ft_pct, :string
    add_column :player_seasons, :orb_per_g, :string
    add_column :player_seasons, :drb_per_g, :string
    add_column :player_seasons, :ast_per_g, :string
    add_column :player_seasons, :stl_per_g, :string
    add_column :player_seasons, :blk_per_g, :string
    add_column :player_seasons, :tov_per_g, :string
    add_column :player_seasons, :pf_per_g, :string
    add_column :player_seasons, :pts_per_g, :string
  end
end

