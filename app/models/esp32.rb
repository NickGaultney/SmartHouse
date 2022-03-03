class Esp32 < IoDevice
	def gpio_template
		"{\"NAME\":\"#{self.device_type}\",\"GPIO\":#{self.tasmota_config.gpio},\"FLAG\":0,\"BASE\":1}".gsub(" ", "%20").gsub("\"", "%22")
	end

	def tasmota_rules
		"rule1%20ON%20switch1%23state%20DO%20Publish%20stat/%25topic%25/switch%20switch1:%25value%25%20ENDON%20ON%20switch2%23state%20DO%20Publish%20stat/%25topic%25/switch%20switch2:%25value%25%20ENDON%20ON%20switch3%23state%20DO%20Publish%20stat/%25topic%25/switch%20switch3:%25value%25%20ENDON%3Brule1%201%3B"
	end
end