class Group < ApplicationRecord
	has_and_belongs_to_many :outputs
	has_and_belongs_to_many :inputs
end
