class AddEndTimeToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :end_time, :time
  end
end
