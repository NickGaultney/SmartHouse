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
			@payload += "template%20#{@device.gpio_template}%3B"
		end

		def append_switch_mode
			if @device.respond_to?(:switch_mode)
				@payload += "SwitchMode%20#{@device.switch_mode}%3B" 
			end
		end

		def append_rules
			unless @device.tasmota_rules.nil?
				@payload += @device.tasmota_rules
			end
		end

		def close_payload
			@payload += "module%200%3B"
			Rails.logger.info @payload
		end
end
