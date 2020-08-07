class CreateAnimes < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :title, null: false
      t.datetime :broadcast_time　
      t.datetime :air_time
      t.string :public_url
      t.string :twitter_account
      t.string :twitter_hash_tag
      t.timestamps
    end
  end
end
