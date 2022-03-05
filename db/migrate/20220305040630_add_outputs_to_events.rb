class AddOutputsToEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events_outputs, id: false do |t|
      t.belongs_to :event
      t.belongs_to :output
    end

    create_table :events_groups, id: false do |t|
      t.belongs_to :event
      t.belongs_to :group
    end
  end
end
