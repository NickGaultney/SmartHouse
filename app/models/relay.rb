class Relay < Output
	def buttonable_action
    	toggle
	end

	def switch_action(state)
		case state
		when 0
			off
		when 1
			on
		when 2
			toggle
		end
	end

	def toggle
		HardWorker.perform_async(self.io_device.topic, 'toggle')
	end

	def on
		HardWorker.perform_async(self.io_device.topic, '1')
	end

	def off
		HardWorker.perform_async(self.io_device.topic, '0')
	end
end