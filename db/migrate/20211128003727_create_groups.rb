class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end

    create_table :inputs_groups, id: false do |t|
      t.belongs_to :input
      t.belongs_to :group
    end

    create_table :outputs_groups, id: false do |t|
      t.belongs_to :output
      t.belongs_to :group
    end
  end
end
