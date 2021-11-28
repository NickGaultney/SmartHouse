class Input < ApplicationRecord
  self.inheritance_column = "input_type"

  belongs_to :io_device   
  has_many :buttons, as: :buttonable
end
