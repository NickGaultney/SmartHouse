class CreateSwitches < ActiveRecord::Migration[5.2]
  def change
    create_table :switches do |t|
      t.string :name
      t.string :topic
      t.string :ip_address
      t.boolean :state
      t.string :coordinates

      t.timestamps
    end
  end
end
