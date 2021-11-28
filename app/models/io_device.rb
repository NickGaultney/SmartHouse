class IoDevice < ApplicationRecord
  self.inheritance_column = "device_type"

  has_many :inputs, dependent: :destroy
  has_many :outputs, dependent: :destroy
  belongs_to :tasmota_config
end
