class Input < ApplicationRecord
  self.inheritance_column = "input_type"

  belongs_to :io_device   
  has_many :buttons, as: :buttonable
  has_and_belongs_to_many :outputs
  has_and_belongs_to_many :groups

  def buttonable_action
    # does nothing at parent level
  end
end
