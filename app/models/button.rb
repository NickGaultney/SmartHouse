class Button < ApplicationRecord
  belongs_to :buttonable, polymorphic: true
end
