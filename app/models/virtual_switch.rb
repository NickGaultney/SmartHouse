class VirtualSwitch < Input
	def buttonable_action
		self.update(state: !self.state)
		ActionCable.server.broadcast(
	     'buttons',
	    	state: self.state,
	    	id: self.buttons.first.id
	    )
		
		super
	end


	private
		def convert_switch_mode
			case self.switch_mode
			when "toggle"
				return 2
			when "follow"
				return self.state ? 1 : 0
			when "inverted follow"
				return !self.state ? 0 : 1
			end
		end
end