class CreateAnimes < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :title, null: false
      t.string :public_url
      t.integer :default_air_time, default: 30, null: false
      t.string :twitter_account
      t.string :twitter_hash_tag
      t.boolean :public, default: false, null: false
      t.timestamps
    end

    add_index :animes, :title, unique: true
  end
end
