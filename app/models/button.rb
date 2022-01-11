class Button < ApplicationRecord
  belongs_to :buttonable, polymorphic: true

  before_create :set_coordinates
  def set_coordinates
    self.coordinates = "1%,1%"
  end
end
