class CreateNetworkDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :network_devices do |t|
      t.string :ip_address
      t.string :topic

      t.timestamps
    end
  end
end
