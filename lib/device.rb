require 'http'

class Device
	attr_reader :payload

	def initialize(device:, type:, host: "192.168.1.96", port: 1883, user: "homeiot", password: "12345678")
		@device = device
		@type = type
		@payload = "http://#{device.ip_address}/cm?cmnd=backlog%20mqtthost%20#{host}%3Bmqttuser%20#{user}%3Bmqttpassword%20#{password}%3Btopic%20#{device.topic}%3B"
		
		self.send("append_#{@type.downcase}")
		append_switch_mode
		close_payload
	end

	def initialize_device
		HTTP.get(@payload)
	end

	private
		def append_sonoff_mini
			if @device.respond_to?(:enable_relay) && !@device.enable_relay
				append_template('{"NAME":"Sonoff MINIR2","GPIO":[32,0,0,0,160,0,0,0,0,224,0,0,0,0],"FLAG":0,"BASE":18}'.gsub(" ", "%20").gsub("\"", "%22"))
			else
				append_template('{"NAME":"Sonoff MINIR2","GPIO":[32,0,0,0,160,0,0,0,224,288,0,0,0,0],"FLAG":0,"BASE":18}'.gsub(" ", "%20").gsub("\"", "%22"))
			end
		end

		def append_esp32
			append_template '{"NAME":"ESP32","GPIO":"[32,0,0,0,160,0,0,0,224,320,0,0,0]","FLAG":0,"BASE":1}'.gsub(" ", "%20").gsub("\"", "%22")
		end

		def append_node_mcu
			append_template "{%22NAME%22:%22NodeMCU%22,%22GPIO%22:[1,166,1,165,161,160,1,1,163,164,162,1,1,1],%22FLAG%22:0,%22BASE%22:18}"
			@payload += "SwitchMode1%2015%3BSwitchMode2%2015%3BSwitchMode3%2015%3BSwitchMode4%2015%3BSwitchMode5%2015%3BSwitchMode6%2015%3BSwitchMode7%2015%3BSwitchMode8%2015%3B"
		end

		def append_template(template)
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
