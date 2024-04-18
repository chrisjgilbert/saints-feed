class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.string :name, null: false
      t.string :base_url, null: false

      t.timestamps
    end

    add_index :sources, :name, unique: true
    add_index :sources, :base_url, unique: true
  end
end
