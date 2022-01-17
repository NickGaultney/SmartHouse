class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.boolean :enabled
      t.string :days_to_repeat
      t.date :start_date
      t.date :end_date
      t.time :time
      t.integer :frequency
      t.string :repeat_type
      t.string :action
      t.references :input, foreign_key: true

      t.timestamps
    end
  end
end
