class AddRulesToTasmotaConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :tasmota_configs, :rules, :string
  end
end
