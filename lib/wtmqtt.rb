class WTMQTT
  def self.get_client(ip: ENV["MQTT_HOST"], port: 1883, user: ENV["MQTT_USERNAME"], password: ENV["MQTT_PASSWORD"], ssl: false)
    MQTT::Client.new({host: ip, port: port, username: user, password: password, ssl: false})
  end

  def self.publish(topic, message)
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

		client.publish(topic, message, false, 1)

	    while waiting_puback do
		  sleep 0.001
		end

	    client.disconnect
	end
  end

  def initialize(ip: ENV["MQTT_HOST"], port: 1883, user: ENV["MQTT_USERNAME"], password: ENV["MQTT_PASSWORD"])
    c = WTMQTT.get_client(ip: ip, port: port, user: user, password: password)
    @client = MQTT::SubHandler.new(c);
    @ip = ip
    @port = port

    register_power
    register_switch

    @client.lockAndListen();
  end

  def register_power
    @client.subscribe_to "stat/+/POWER" do |data, topic|
      puts "#{Time.now}: New message received on topic: #{topic[0]}\n>>>#{data}"
      sonoffminir2_action(topic[0], data)
    end
  end

  def register_switch
    @client.subscribe_to "stat/+/switch" do |data, topic|
      puts "#{Time.now}: New message received on topic: #{topic[0]}\n>>>#{data}"
      switch_action(topic[0], data)
    end
  end

  private
    def get_input_index(data)
      data.split(":")[0][5...-1].to_i
    end

    def get_input_state(data)
      data.split(":")[1].to_i
    end

    def get_device_id(topic)
      topic.split("_")[-2]
    end

    def relay_state(data)
      data == "OFF" ? false : true
    end

    def update_switch_state(switch, state)
      converted_state = nil
      case state
      when 0
        converted_state = false
      when 1
        converted_state = true
      when 2
        converted_state = !switch.state
      end
      
      switch.update(state: converted_state)
      unless switch.buttons.empty?
        ActionCable.server.broadcast(
            'buttons',
            state: converted_state,
            id: switch.buttons.first.id
          )
      end
    end

    def switch_action(topic, data)
      return unless SonoffMiniR2.exists?(get_device_id(topic))

      device = SonoffMiniR2.find(get_device_id(topic))
      switch = device.inputs[get_input_index(data)]
      state = get_input_state(data)

      unless switch.nil?
        update_switch_state(switch, state)
        
        switch.all_outputs.each do |output|
          output.switch_action(state)
        end
      end
    end

    def sonoffminir2_action(topic, data)
      return unless SonoffMiniR2.exists?(get_device_id(topic))

      device = SonoffMiniR2.find(get_device_id(topic))
      relay = device.outputs.first
      unless relay.nil?
        relay.update(state: relay_state(data))

        unless relay.buttons.empty?
          ActionCable.server.broadcast(
              'buttons',
              state: relay_state(data),
              id: relay.buttons.first.id
            )
        end
      end
    end
end