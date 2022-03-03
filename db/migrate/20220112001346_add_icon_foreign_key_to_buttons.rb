class AddIconForeignKeyToButtons < ActiveRecord::Migration[5.2]
  def change
    remove_column :buttons, :icon, :string
    add_reference :buttons, :icon, foreign_key: true
  end
end
