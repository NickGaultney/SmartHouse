class Icon < ApplicationRecord
	before_destroy :delete_svg
	def delete_svg
		path = Rails.root.join('app', 'views', 'icons', "_#{self.name}.html.erb")
		File.delete(path) if File.exist?(path)
	end
end