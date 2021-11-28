class CreateIoDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :io_devices do |t|
      t.string :name
      t.string :topic
      t.string :ip_address
      t.string :device_type
      t.references :tasmota_config, foreign_key: true

      t.timestamps
    end
  end
end
