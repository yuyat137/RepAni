class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.references :anime
      t.integer :num, null: false
      t.string :subtitle
      t.datetime :broadcast_datetime
      t.integer :exceptional_air_time, default: nil
      t.integer :state, default: 1, null: false
      t.timestamps
    end

    add_index :episodes, [:anime_id, :num], unique: true
  end
end
