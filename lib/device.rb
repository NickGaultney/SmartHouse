require 'http'

class Device
	attr_reader :payload

	def initialize(device:, host: ENV["MQTT_HOST"], port: 1883, user: ENV["MQTT_USERNAME"], password: ENV["MQTT_PASSWORD"])
		@device = device
		@payload = "http://#{device.ip_address}/cm?cmnd=backlog%20mqtthost%20#{host}%3Bmqttuser%20#{user}%3Bmqttpassword%20#{password}%3Btopic%20#{device.topic}%3B"
		
		append_template
		append_switch_mode
		append_rules
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

		def append_rules
			rule = "rule1%20ON%20switch1#state%20DO%20Backlog%20Power1%20%value%%3B%20Publish%20stat/%topic%/switch%20switch1:%value%%20ENDON%3Brule1%201%3B"
			@payload += rule
		end

		def close_payload
			@payload += "module%200%3B"
		end
end
