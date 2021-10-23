module ButtonsHelper
	def color_button(button)
		if Device.find(button.device_id).state
			return "#FFA500"
		else
			return "#000000"
		end
	end
end
