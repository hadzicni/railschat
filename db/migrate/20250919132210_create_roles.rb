class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.string :color
      t.text :permissions

      t.timestamps
    end
  end
end
