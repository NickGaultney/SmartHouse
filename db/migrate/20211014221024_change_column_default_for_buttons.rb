class ChangeColumnDefaultForButtons < ActiveRecord::Migration[5.2]
  def change
    change_column_default :buttons, :coordinates, from: nil, to: "1%,1%"
  end
end
