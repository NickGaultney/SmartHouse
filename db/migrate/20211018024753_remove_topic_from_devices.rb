class RemoveTopicFromDevices < ActiveRecord::Migration[5.2]
  def change
    remove_column :devices, :mqtt_topic
  end
end
