class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end

    create_table :groups_inputs, id: false do |t|
      t.belongs_to :group
      t.belongs_to :input
    end

    create_table :groups_outputs, id: false do |t|
      t.belongs_to :group
      t.belongs_to :output
    end
  end
end
