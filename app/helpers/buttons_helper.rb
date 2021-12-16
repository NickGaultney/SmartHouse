module ButtonsHelper
	def color(button)
		if button.buttonable.respond_to?(:state)
			if button.buttonable.state
				return "#FFA500"
			else
				return "#000000"
			end
		else
			return "#000000"
		end
	end

	def name(button)
		if button.buttonable.respond_to?(:name)
			return button.buttonable.name
		else
			return ""
		end
	end
end
