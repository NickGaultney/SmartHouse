class AddIpToSlaveSwitch < ActiveRecord::Migration[5.2]
  def change
    add_column :slave_switches, :ip_address, :string
  end
end
