class ChangeColumnDefaultsForDevices < ActiveRecord::Migration[5.2]
  def change
    change_column_default :devices, :mqtt_port, from: nil, to: "1883"
  end
end
