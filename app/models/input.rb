class Input < ApplicationRecord

	after_create :setup_device
	def setup_device
		self.update(topic: self.class.to_s + "_" + self.id.to_s + "_" + self.name.to_s.gsub(/[\s]/, "_"))
		ip_address = self.ip_address
		mqtt_host = "192.168.1.96"
		mqtt_user = "homeiot"
		mqtt_password = "12345678"
		topic = self.topic
		template = "{%22NAME%22:%22NodeMCU%22,%22GPIO%22:[1,166,1,165,161,160,1,1,163,164,162,1,1,1],%22FLAG%22:0,%22BASE%22:18}"

		"SwitchMode1%2015%3BSwitchMode2%2015%3BSwitchMode3%2015%3BSwitchMode4%2015%3BSwitchMode5%2015%3BSwitchMode6%2015%3BSwitchMode7%2015%3BSwitchMode8%2015%3B"
		HTTP.get("http://#{ip_address}/cm?cmnd=backlog%20mqtthost%20#{mqtt_host}%3Bmqttuser%20#{mqtt_user}%3Bmqttpassword%20#{mqtt_password}%3Btopic%20#{topic}%3Btemplate%20#{template}%3Bmodule%200%3BSerialLog%200%3BSwitchMode1%2015%3BSwitchMode2%2015%3BSwitchMode3%2015%3BSwitchMode4%2015%3BSwitchMode5%2015%3BSwitchMode6%2015%3BSwitchMode7%2015%3BSwitchMode8%2015%3B")
	end
end
