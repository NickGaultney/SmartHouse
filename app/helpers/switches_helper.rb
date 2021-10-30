module SwitchesHelper
	def color_switch(switch)
		if switch.state
			return "#FFA500"
		else
			return "#000000"
		end
	end
end
