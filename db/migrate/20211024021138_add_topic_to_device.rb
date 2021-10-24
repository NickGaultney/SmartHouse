class AddTopicToDevice < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :topic, :string
  end
end
