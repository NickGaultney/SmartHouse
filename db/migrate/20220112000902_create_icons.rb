class CreateIcons < ActiveRecord::Migration[5.2]
  def change
    create_table :icons do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end
