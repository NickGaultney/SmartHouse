class Button < ApplicationRecord
  belongs_to :icon
  belongs_to :buttonable, polymorphic: true
  validates :icon, :presence => true

  before_create :set_coordinates
  def set_coordinates
    self.coordinates = "1%,1%"
  end
end
