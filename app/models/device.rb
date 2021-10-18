class Device < ApplicationRecord
	has_many :buttons

	after_create :setup_device
	def setup_device
		ip_address = self.ip_address
		mqtt_host = "192.168.1.96"
		mqtt_user = "homeiot"
		mqtt_password = "12345678"
		topic = self.id.to_s + "_" + self.name.to_s
		template = "{%22NAME%22:%22Sonoff%20MINIR2%22,%22GPIO%22:[17,0,0,0,9,0,0,0,21,56,0,0,0],%22FLAG%22:0,%22BASE%22:1}"

		HTTP.get("http://#{ip_address}/cm?cmnd=backlog%20mqtthost%20#{mqtt_host}%3Bmqttuser%20#{mqtt_user}%3Bmqttpassword%20#{mqtt_password}%3Btopic%20#{topic}%3Btemplate%20#{template}%3B")
	end
end
