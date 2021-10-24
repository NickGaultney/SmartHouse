class AddTopicToSlaveSwitch < ActiveRecord::Migration[5.2]
  def change
    add_column :slave_switches, :topic, :string
  end
end
