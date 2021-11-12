class AddSwitchModeToSlaveSwitch < ActiveRecord::Migration[5.2]
  def change
    add_column :slave_switches, :switch_mode, :string
  end
end
