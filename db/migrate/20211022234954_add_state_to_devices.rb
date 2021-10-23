class AddStateToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :state, :boolean
  end
end
