class CreateTasmotaConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :tasmota_configs do |t|
      t.string :name
      t.string :gpio
      t.string :switch_state

      t.timestamps
    end
  end
end
