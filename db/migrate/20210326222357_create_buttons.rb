class CreateButtons < ActiveRecord::Migration[5.2]
  def change
    create_table :buttons do |t|
      t.string :name
      t.string :coordinates
      t.references :device

      t.timestamps
    end
  end
end
