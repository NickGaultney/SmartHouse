class CreateInputs < ActiveRecord::Migration[5.2]
  def change
    create_table :inputs do |t|
      t.string :name
      t.string :nickname
      t.string :switch_mode
      t.boolean :state
      t.string :input_type
      t.references :io_device, foreign_key: true

      t.timestamps
    end
  end
end
