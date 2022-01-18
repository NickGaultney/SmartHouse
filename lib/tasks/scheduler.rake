task :scheduler => :environment do
	loop do 
		begin
			File.open("tmp/pids/scheduler.pid", "w") do |file|
				file.write(Process.pid.to_s)
			end

			#events = Event.where("start_date <= :now", now: Time.now).where(enabled: true)
			events = Event.where(enabled: true)
			events.each do |event|
				Thread.new do
					start(event)
				end

				puts "new thread started"
			end

			sleep
		rescue => e
		    p e
	    ensure
 			File.new("tmp/pids/scheduler.pid").tap { |f| `kill -9 #{f.read.to_i}` }
		end
	end
end

def start(event)
	now = Time.now
	# Ensure that event hasn't expired 
	if !event.end_date.nil?
		if event.end_date.to_time <= now
			event.update(enabled: false)
			log "Event passed due. Disabling..."
			return
		end
	elsif event.start_date.to_time > now
		log "Sleeping for #{((event.start_date.to_time - now)/60.0)/60.0} hours until event starts"
		sleep(event.start_date.to_time - now)
	end

	loop do
		sleep_until_next_event(event)
		puts "Time to do stuff"
		case event.action
		when "on"
			event.input.send("on")
		when "off"
			event.input.send("off")
		when "toggle"
			event.input.send("toggle")
		end
	end
end

def sleep_until_next_event(event)
	now = Time.now
	day = now.to_date
	remaining_time_today = 0
	days_until_event = 0

	8.times do |i|
		days_until_event = i
		# Verify event should run today
		if event.days[day.wday]
			if i == 0
				break if event.is_after(now.hour, now.min)
			else
				break
			end
		end
		day = day.next_day
	end

	if Time.now >= event.time
		remaining_time_today = Time.now.to_date.next_day.to_time - Time.now
	end

	days_until_event -= 1 unless days_until_event == 0

	total_time_in_seconds = remaining_time_today + (days_until_event*24*60*60) + event.time_in_seconds
	log "Sleeping for #{total_time_in_seconds} seconds"
	sleep(total_time_in_seconds)
end

def log(message)
	puts "id: #{Thread.current.object_id} -- #{message}"
end