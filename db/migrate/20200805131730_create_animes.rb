class CreateAnimes < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :title, null: false
      t.string :title_short
      t.string :public_url
      t.string :twitter_account
      t.string :twitter_hash_tag
      t.integer :target_sex
      t.integer :sequel
      t.timestamps
    end
  end
end
