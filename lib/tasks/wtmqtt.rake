require 'uri'
require 'net/http'

namespace :wtmqtt do
	task :subscribe => :environment do
		def send_email(to="nmgaultney@gmail.com", opts={})
			eval File.read("#{Rails.root}/lib/tasks/smtp_add_tls_support.rb")
			Net::SMTP.enable_tls() 
		    # Send an email. In Ruby, the ||= operator means 'only assign the
		    # new value if the value has not been set yet'
		    opts[:server]      ||= 'smtp.gmail.com'
		    opts[:port]        ||= 587
		    opts[:ehlo_domain] ||= 'localhost'
		    opts[:username]    ||= 'nmgaultney@gmail.com'
		    opts[:password]    ||= ENV["SMTP_PASSWORD"]
		    opts[:from]        ||= 'nmgaultney@gmail.com'
		    opts[:from_alias]  ||= 'Nick Mark'
		    opts[:subject]     ||= 'SmartHouse'
		    opts[:body]        ||= 'MQTT Died...again.'
		 
		    # the following says 'create a new string called msg containing everything
		    # from here to the END_OF_MESSAGE marker'
		    # then, we fill in the email with all of the values we filled in above. Note
		    # that there has to be a newline between the subject and the body of the
		    # message.
		    # This is a plaintext message - to send HTML emails, we would need a more
		    # complex template.
		    msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}
 
#{opts[:body]}
END_OF_MESSAGE
		    Net::SMTP.start(opts[:server], opts[:port], opts[:ehlo_domain],
		                    opts[:username], opts[:password], :plain) do |smtp|
		        smtp.send_message msg, opts[:from], to
		    end
		end

		error_type = nil
		error_message = nil
		begin
			client = WTMQTT.new
		rescue Exception => e
		    error_type = e.class
		    error_message = e.full_message
	    ensure
 			opts = {
            	:body       => "Hey,\nsomething happened with the MQTT service. Error type " + error_type.to_s +
            	" the status code " + error_message + ". \n\nYou should check it out."
        	}

        	send_email "nmgaultney@gmail.com", opts
		end
	end
end