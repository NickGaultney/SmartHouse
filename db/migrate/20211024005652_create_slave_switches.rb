class CreateSlaveSwitches < ActiveRecord::Migration[5.2]
  def change
    create_table :slave_switches do |t|
      t.string :name
      t.references :switch, foreign_key: true

      t.timestamps
    end
  end
end
