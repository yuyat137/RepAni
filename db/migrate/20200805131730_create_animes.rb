class CreateAnimes < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :title, null: false
      t.integer :year
      t.integer :season
      t.datetime :broadcast_datetime
      t.integer :air_time
      t.string :public_url
      t.string :twitter_account
      t.string :twitter_hash_tag
      t.timestamps
    end
  end
end
