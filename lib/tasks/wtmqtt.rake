namespace :wtmqtt do
	task :subscribe => :environment do
		loop do 
			error_type = nil
			error_message = nil
			begin
				client = WTMQTT.new
				client.connect
				client.subscribe("stat/+/POWER")
				client.subscribe("stat/+/switch")

				sleep
			rescue => e
			    error_type = e.class
			    error_message = e.full_message
		    ensure
	 			error_type = "Unclear error...." if error_type.nil?
	 			open('/home/ubuntu/SmartHouse/lib/tasks/logs') do |f|
				  f.puts Time.now.to_s + " >>> #{error_type}: #{error_message}\n\n"
				end
			end
		end
	end
end