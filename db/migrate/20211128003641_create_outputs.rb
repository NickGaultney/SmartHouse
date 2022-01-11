class CreateOutputs < ActiveRecord::Migration[5.2]
  def change
    create_table :outputs do |t|
      t.string :name
      t.string :nickname
      t.boolean :state
      t.string :output_type
      t.references :io_device, foreign_key: true

      t.timestamps
    end
  end
end
