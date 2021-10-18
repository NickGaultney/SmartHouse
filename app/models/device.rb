class Device < ApplicationRecord
	has_many :buttons

	after_create :setup_device
	def setup_device
		ip_address = self.ip_address
		mqtt_host = "192.168.1.96"
		mqtt_user = "homeiot"
		mqtt_password = "12345678"
		topic = self.id.to_s + "_" + self.name.to_s
		HTTP.get("http://#{ip_address}/cm?cmnd=backlog%20mqtthost%20#{mqtt_host}%3Bmqttuser%20#{mqtt_user}%3Bmqttpassword%20#{mqtt_password}%3Btopic%20#{topic}%3B")
	end
end
