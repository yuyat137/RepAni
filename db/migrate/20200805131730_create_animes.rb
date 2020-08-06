class CreateAnimes < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :title, null: false
      t.string :title_short1
      t.string :title_short2
      t.string :title_short3
      t.string :public_url
      t.string :twitter_account
      t.string :twitter_hash_tag
      t.integer :sex
      t.integer :sequel
      t.timestamps
    end
  end
end
