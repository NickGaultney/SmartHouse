class AddTopicToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :mqtt_topic, :string
  end
end
