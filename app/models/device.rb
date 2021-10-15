class Device < ApplicationRecord
	has_secure_password
	has_many :buttons
end
