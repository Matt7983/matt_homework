class AddAvailableToCourse < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :available, :boolean, default: true, after: :description
  end
end
