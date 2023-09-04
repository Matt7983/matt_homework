class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.references :chapter, null: false
      t.string :name, null: false
      t.text :description
      t.text :content, null: false
      t.integer :sequence, default: 0, null: false

      t.timestamps
    end
  end
end
