Rails.configuration.after_initialize do
	class WTMQTT
		def self.toggle_light(topic)
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
			else
				#Rails.logger.info "Successfully connected to #{device.ip_address}"
				client.publish("cmnd/#{topic}/Power", "toggle", false, 1)

				while waiting_puback do
				  sleep 0.001
				end

				client.disconnect
			end
		end

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
			  id, type = parse_topic(packet.topic)
			  device = nil

			  if type == "Switch"
			  	  device = Switch.find(id)
				  device.update(state: get_state(packet.payload))
			  elsif type == "SlaveSwitch"
			  	  device = Switch.find(SlaveSwitch.find(id).device_id)
				  toggle_light(device.topic)
			  end

			  HTTP.get("http://localhost:3000/bump?id=#{device.id}")
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
	end
end