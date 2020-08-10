class CreateAnimeTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :anime_terms do |t|
      t.belongs_to :anime, null: false
      t.belongs_to :term, null: false
      t.timestamps
    end

    add_index :anime_terms, [:anime_id, :term_id], unique: true
  end
end
