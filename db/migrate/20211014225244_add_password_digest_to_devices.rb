class AddPasswordDigestToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :password_digest, :string
  end
end
