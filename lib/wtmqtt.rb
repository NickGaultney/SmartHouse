class WTMQTT

	def self.publish
		client = PahoMqtt::Client.new({host: ENV["MQTT_HOST"], port: 1883, ssl: false, username: ENV["MQTT_USERNAME"], password: ENV["MQTT_PASSWORD"]})

		### Register a callback for puback event when receiving a puback
		waiting_puback = true
		client.on_puback do
		  waiting_puback = false
		  Rails.logger.info "Message Acknowledged"
		end

		begin 
			client.connect(ENV["MQTT_HOST"], 1883)
		rescue PahoMqtt::Exception
		    #Rails.logger.info "Failed to connect to #{device.ip_address}: is #{device.name} online?"
		else

			yield(client)

		    while waiting_puback do
			  sleep 0.001
			end

		    client.disconnect
		end
	end

	def initialize(ip: ENV["MQTT_HOST"], port: 1883, user: ENV["MQTT_USERNAME"], password: ENV["MQTT_PASSWORD"])
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

		  self.send(get_device_type(packet).downcase + "_action", packet)
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

=begin
	def toggle_light(topic)
		@client.publish("cmnd/#{topic}/Power", "toggle", false, 1)
	end

	def change_light(topic, payload)
		@client.publish("cmnd/#{topic}/Power", payload, false, 1)
	end
	def switch_action(id, payload)
		device = Switch.find(id)
		device.update(state: get_state(payload))

		HTTP.get("http://localhost:3000/bump?id=#{device.id}")
	end

	def slaveswitch_action(id, payload)
		puts SlaveSwitch.find(id).switch_id
		device = Switch.find(SlaveSwitch.find(id).switch_id)
	    change_light(device.topic, payload)

	    HTTP.get("http://localhost:3000/bump?id=#{device.id}")
	end
	def update_config(topic, command)
		self.connect

		@client.publish("cmnd/#{topic}/backlog", command, false, 1)

		self.disconnect
	end
=end

	private
		def confirm_subscription
			### Register a callback on suback to assert the subcription
			@client.on_suback do
			    puts "Subscribed"
			end
		end

		def confirm_publish
			### Register a callback for puback event when receiving a puback
			@client.on_puback do
				waiting_puback = false
				puts "Message Acknowledged"
			end
		end

		def get_device_type(packet)
			packet.topic.split("/")[1].split("_")[-1]
		end

		def get_device_id(packet)
			packet.topic.split("/")[1].split("_")[-2]
		end

		def io_type(packet)
			packet.topic.split("/")[2]
		end

		def relay_state(packet)
			packet.payload == "OFF" ? false : true
		end

		def switch_state(packet)
			packet.payload.split(":")[1] == "0" ? false : true
		end

		def sonoffminir2_action(packet)
			type = io_type(packet).downcase
			device = SonoffMiniR2.find(get_device_id(packet))

			if type == 'power'
				relay = device.outputs.first
				relay.update(state: relay_state(packet))

				unless relay.buttons.empty?
					ActionCable.server.broadcast(
				      'buttons',
				      state: relay_state(packet),
				      id: relay.buttons.first.id
				    )
				end
			elsif type == 'switch'
				switch = device.inputs.first
				switch.update(state: switch_state(packet))

				unless switch.buttons.empty?
					ActionCable.server.broadcast(
				      'buttons',
				      state: switch_state(packet),
				      id: switch.buttons.first.id
				    )
				end
			end	
		end
end