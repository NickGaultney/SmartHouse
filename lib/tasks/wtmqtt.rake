namespace :wtmqtt do
	task :subscribe => :environment do
		loop do 
			begin
				client = WTMQTT.new
				client.connect
				client.subscribe("stat/+/POWER")
				client.subscribe("stat/+/switch")

				File.open("tmp/pids/mqtt.pid", "w") do |file|
					file.write(Process.pid.to_s)
				end

				loop do
					sleep 60
				end
			rescue => e
			    p e
		    ensure
	 			File.new("tmp/pids/mqtt.pid").tap { |f| `kill -9 #{f.read.to_i}` }
			end
		end
	end
end