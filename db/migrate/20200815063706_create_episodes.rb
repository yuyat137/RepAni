class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.references :anime
      t.integer :num, null: false
      t.string :subtitle
      t.datetime :broadcast_datetime
      t.integer :air_time, default: nil, null: false
      # 本番環境ではdefault: false
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :episodes, [:anime_id, :num], unique: true
  end
end
