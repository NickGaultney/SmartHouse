class Output < ApplicationRecord
  self.inheritance_column = "output_type"

  belongs_to :io_device   
  has_many :buttons, as: :buttonable

  def buttonable_action
    # does nothing at parent level
  end
end
