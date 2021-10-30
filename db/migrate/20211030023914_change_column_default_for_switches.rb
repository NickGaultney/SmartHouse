class ChangeColumnDefaultForSwitches < ActiveRecord::Migration[5.2]
  def change
    change_column_default :switches, :coordinates, from: nil, to: "1%,1%"
  end
end
