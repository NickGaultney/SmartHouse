class RemoveInputIdFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :input_id
  end
end
