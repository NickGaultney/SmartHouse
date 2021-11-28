class CreateButtons < ActiveRecord::Migration[5.2]
  def change
    create_table :buttons do |t|
      t.string :coordinates
      t.string :icon
      t.references :buttonable, polymorphic: true

      t.timestamps
    end
  end
end
