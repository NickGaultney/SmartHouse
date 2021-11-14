class AddEnableRelayToSlaveSwitch < ActiveRecord::Migration[5.2]
  def change
    add_column :slave_switches, :enable_relay, :boolean
  end
end
