class Relay < Output
	def buttonable_action
    	toggle
	end

	def toggle
		WTMQTT.publish do |client|
			client.publish("cmnd/#{self.io_device.topic}/Power", "toggle", false, 1)
		end
	end

	def on
		WTMQTT.publish do |client|
			client.publish("cmnd/#{self.io_device.topic}/Power", "0", false, 1)
		end
	end

	def off
		WTMQTT.publish do |client|
			client.publish("cmnd/#{self.io_device.topic}/Power", "1", false, 1)
		end
	end
end