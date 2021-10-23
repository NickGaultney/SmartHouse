Rails.configuration.after_initialize do
	class WTMQTT
		def initialize(ip:, port:, user:, password:)
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
			  device = Device.find(get_id(packet.topic))
			  device.update_attribute("state", get_state(packet.payload))
			end
		end

		def connect
			begin 
				@client.connect(@ip, @port, @client.keep_alive, true, @client.blocking)
			rescue PahoMqtt::Exception
			    #Rails.logger.info "Failed to connect to #{device.ip_address}: is #{device.name} online?"
			end
		end

		def disconnect
			@client.disconnect
		end

		def subscribe(topic)
			### Subscribe to a topic
	    	@client.subscribe([topic, 1])
		end

		def toggle_light(topic)

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

			def get_id(topic)
				topic.split("/")[1].split("_")[0]
			end

			def get_state(payload)
				payload == "OFF" ? false : true
			end
	end
	
	client = WTMQTT.new(ip: "192.168.1.96", port: 1883, user: "homeiot", password: "12345678")
	client.connect
	client.subscribe("stat/+/POWER")
end