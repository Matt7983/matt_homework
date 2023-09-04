class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.references :course, null: false
      t.string :name, null: false
      t.integer :sequence, default: 0, null: false

      t.timestamps
    end
  end
end
