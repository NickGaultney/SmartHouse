class Group < ApplicationRecord
	has_many :buttons, as: :buttonable

	def buttonable_action

	end
end
