namespace :wtmqtt do
	task :subscribe => :environment do
		client = WTMQTT.new(ip: "192.168.1.96", port: 1883, user: "homeiot", password: "12345678")
		client.connect
		client.subscribe("stat/+/POWER")

		File.open("tmp/pids/mqtt.pid", "w") do |file|
			file.write(Process.pid.to_s)
		end

		loop do
			sleep 60
		end
	end
end
