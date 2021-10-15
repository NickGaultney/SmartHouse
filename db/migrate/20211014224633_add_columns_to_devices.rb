class AddColumnsToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :mqtt_port, :string
    add_column :devices, :mqtt_user, :string
    add_column :devices, :mqtt_topic, :string
  end
end
