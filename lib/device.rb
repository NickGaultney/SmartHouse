require 'http'

class Device
	attr_reader :payload

	def initialize(device:, host: ENV["MQTT_HOST"], port: 1883, user: ENV["MQTT_USERNAME"], password: ENV["MQTT_PASSWORD"])
		@device = device
		@payload = []
		@http_payload = "http://#{device.ip_address}/cm?cmnd=backlog" +
		httpify(" mqtthost #{host};mqttuser #{user};mqttpassword #{password};topic #{device.topic};")

		#@payload << ["mqtthost", host]
		#@payload << ["mqttuser", user] 
		#@payload << ["mqttpassword", password] 
		#@payload << ["topic", device.topic] 

		append_template
		append_switch_mode
		append_rules
		close_payload
	end

	def initialize_device
		HTTP.get(@http_payload)

		#backlog = ""
		#@payload.each do |command| 
		#	backlog += "#{command[0]} #{command[1]}; "
		#end

		#HardWorker.perform_async(full_topic(@device.topic, "backlog"), backlog)
	end

	private
		def append_template
			@http_payload += httpify("template #{@device.gpio_template};")
			#HardWorker.perform_async(full_topic(@device.topic, "template"), @device.gpio_template)
			#@payload << ["template", @device.gpio_template] 
		end

		def append_switch_mode
			if @device.respond_to?(:switch_mode)
				@payload += httpify("SwitchMode #{@device.switch_mode};") 
				#@payload << ["SwitchMode", @device.switch_mode] 
			end
		end

		def append_rules
			unless @device.tasmota_rules.nil?
				@http_payload += httpify(@device.tasmota_rules)
				#HardWorker.perform_async(full_topic(@device.topic, "rule1"), @device.tasmota_rules)
				#HardWorker.perform_async(full_topic(@device.topic, "rule1"), "1")
				#@payload << ["rule1", @device.tasmota_rules] 
				#@payload << ["rule1", 1]
			end
		end

		def close_payload
			@http_payload += httpify("module 0;")
			#@payload << ["module", 0]
			Rails.logger.info @http_payload
		end

		private
			def full_topic(device_topic, command)
				"cmnd/#{device_topic}/#{command}"
			end

			def httpify(command)
				command.gsub("%", "%25").gsub(" ", "%20").gsub("\"", "%22").gsub(";", "%3B").gsub("#", "%23")
			end
end
