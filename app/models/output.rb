class Output < ApplicationRecord
  self.inheritance_column = "output_type"

  belongs_to :io_device   
  has_many :buttons, as: :buttonable
end
