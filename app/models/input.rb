class Input < ApplicationRecord

	after_create :setup_device
	def setup_device
		self.update(topic: self.class.to_s + "_" + self.id.to_s + "_" + self.name.to_s.gsub(/[\s]/, "_"))
		ip_address = self.ip_address
		mqtt_host = "192.168.1.96"
		mqtt_user = "homeiot"
		mqtt_password = "12345678"
		topic = self.topic
		template = "{%22NAME%22:%22Sonoff%20MINIR2%22,%22GPIO%22:[160,0,161,0,162,163,0,0,0,0,0,0,0],%22FLAG%22:0,%22BASE%22:1}"

		HTTP.get("http://#{ip_address}/cm?cmnd=backlog%20mqtthost%20#{mqtt_host}%3Bmqttuser%20#{mqtt_user}%3Bmqttpassword%20#{mqtt_password}%3Btopic%20#{topic}%3Btemplate%20#{template}%3Bmodule%200%3B")
	end
end
