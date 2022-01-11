class JoinInputsOutputs < ActiveRecord::Migration[5.2]
  def change
    create_table :inputs_outputs, id: false do |t|
      t.belongs_to :input
      t.belongs_to :output
    end
  end
end
