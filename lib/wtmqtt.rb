class WTMQTT
	def initialize(ip: "192.168.1.96", port: 1883, user: "homeiot", password: "12345678")
		@client = PahoMqtt::Client.new({host: ip, port: port, ssl: false, username: user, password: password})
		@ip = ip
		@port = port

		confirm_subscription
		confirm_publish
		on_message
	end

	def on_message
		@client.on_message do |packet|
		  puts "New message received on topic: #{packet.topic}\n>>>#{packet.payload}"
		  id, type = parse_topic(packet.topic)
		  device = nil

		  self.send(type.downcase + "_action", id, packet.payload)
		end
	end

	def connect
		begin 
			@client.connect(@ip, @port, @client.keep_alive, true, @client.blocking)
		rescue PahoMqtt::Exception
		    #Rails.logger.info "Failed to connect to #{device.ip_address}: is #{device.name} online?"
		end

		return self
	end

	def disconnect
		@client.disconnect
	end

	def subscribe(topic)
		### Subscribe to a topic
    	@client.subscribe([topic, 1])
	end

	def toggle_light(topic)
		@client.publish("cmnd/#{topic}/Power", "toggle", false, 1)
	end

	def switch_action(id, payload)
		device = Switch.find(id)
		device.update(state: get_state(payload))

		HTTP.get("http://localhost:3000/bump?id=#{device.id}")
	end

	def slaveswitch_action(id, payload)
		device = Switch.find(SlaveSwitch.find(id).switch_id)
	    toggle_light(device.topic)

	    HTTP.get("http://localhost:3000/bump?id=#{device.id}")
	end

	private
		def confirm_subscription
			### Register a callback on suback to assert the subcription
			@client.on_suback do
			    puts "Subscribed"
			end
		end

		def confirm_publish
			### Register a callback for puback event when receiving a puback
			waiting_puback = true
			@client.on_puback do
				waiting_puback = false
				puts "Message Acknowledged"
			end
		end

		def parse_topic(topic)
			split = topic.split("/")[1].split("_")
			return [split[1], split[0]]
		end

		def get_state(payload)
			payload == "OFF" ? false : true
		end

		def self.connect
			client = PahoMqtt::Client.new({host: "192.168.1.96", port: 1883, ssl: false, username: 'homeiot', password: '12345678'})
  
			### Register a callback for puback event when receiving a puback
			waiting_puback = true
			client.on_puback do
				waiting_puback = false
			end

			begin 
				client.connect("192.168.1.96", 1883)
			rescue PahoMqtt::Exception
				#Rails.logger.info "Failed to connect to #{device.ip_address}: is #{device.name} online?"
				return nil
			else
				return [client, waiting_puback]
			end
		end
end