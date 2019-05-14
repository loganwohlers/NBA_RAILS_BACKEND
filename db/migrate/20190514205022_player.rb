class Player < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :team_id
      t.string :position
      t.boolean :out

      t.timestamps
    end
  end
end
