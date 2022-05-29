namespace :wtmqtt do
	task :subscribe => :environment do
		error_type = nil
		error_message = nil
		begin
			client = WTMQTT.new
			client.connect
			client.subscribe("stat/+/POWER")
			client.subscribe("stat/+/switch")

			#File.open("tmp/pids/mqtt.pid", "w") do |file|
			#	file.write(Process.pid.to_s)
			#end

			sleep
		rescue e
		    error_type = e.class
		    error_message = e.message
	    ensure
 			#File.new("tmp/pids/mqtt.pid").tap { |f| `kill -9 #{f.read.to_i}` }
 			error_type = "Unclear error...." if error_type.nil?
 			open('/home/ubuntu/SmartHouse/lib/tasks/logs', 'a') do |f|
			  f.puts Time.now.to_s + " >>> #{error_type}: #{error_message}"
			end
		end
	end
end