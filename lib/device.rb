require 'http'

class Device
	attr_reader :payload

	def initialize(device:, host: "192.168.1.96", port: 1883, user: "homeiot", password: "12345678")
		@device = device
		@payload = "http://#{device.ip_address}/cm?cmnd=backlog%20mqtthost%20#{host}%3Bmqttuser%20#{user}%3Bmqttpassword%20#{password}%3Btopic%20#{device.topic}%3B"
		
		append_template
		append_switch_mode
		close_payload
	end

	def initialize_device
		HTTP.get(@payload)
	end

	private
		def append_template
			template = "{\"NAME\":\"#{@device.device_type}\",\"GPIO\":#{@device.tasmota_config.gpio},\"FLAG\":0,\"BASE\":18}".gsub(" ", "%20").gsub("\"", "%22")
			@payload += "template%20#{template}%3B"
		end

		def append_switch_mode
			if @device.respond_to?(:switch_mode)
				@payload += "SwitchMode%20#{@device.switch_mode}%3B" 
			end
		end

		def close_payload
			@payload += "module%200%3B"
		end
end
