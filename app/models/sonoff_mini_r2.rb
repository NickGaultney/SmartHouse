class SonoffMiniR2 < IoDevice
	def generate_io
		#Input.create(name: "#{self.name}_SMR2_#{self.id}_in", input_type: "Switch", io_device: self)
		#Output.create(name: "#{self.name}_SMR2_#{self.id}_out", output_type: "Relay", io_device: self)

		Input.create(name: "#{self.name}", input_type: "Switch", io_device: self)
		Output.create(name: "#{self.name}", output_type: "Relay", io_device: self)
	end

	def gpio_template
		"{\"NAME\":\"#{self.device_type}\",\"GPIO\":#{self.tasmota_config.gpio},\"FLAG\":0,\"BASE\":18}".gsub(" ", "%20").gsub("\"", "%22")
	end

	def tasmota_rules
		"rule1%20ON%20switch1#state%20DO%20Backlog%20Power1%20%value%%3B%20Publish%20stat/%topic%/switch%20switch1:%value%%20ENDON%3Brule1%201%3B"
	end
end