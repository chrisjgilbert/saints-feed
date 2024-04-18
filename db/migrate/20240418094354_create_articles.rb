class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.text :url, null: false
      t.text :title, null: false
      t.text :description
      t.text :image_path
      t.references :source, null: false, foreign_key: true

      t.timestamps
    end

    add_index :articles, :url, unique: true
  end
end
