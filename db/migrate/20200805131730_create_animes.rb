class CreateAnimes < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :title, null: false
      t.string :public_url
      t.integer :default_air_time
      t.string :twitter_account
      t.string :twitter_hash_tag
      # 開発時の対応でdefault: 1としている。本番ではdeafult: 0
      t.boolean :state, default: 1, null: false
      t.timestamps
    end

    add_index :animes, :title, unique: true
  end
end
