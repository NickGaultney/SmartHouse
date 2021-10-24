namespace :wtmqtt do
	task :subscribe => :environment do
		client = WTMQTT.new(ip: "192.168.1.96", port: 1883, user: "homeiot", password: "12345678")
		client.connect
		client.subscribe("stat/+/POWER")

		while true
			sleep 60
		end
	end
end
