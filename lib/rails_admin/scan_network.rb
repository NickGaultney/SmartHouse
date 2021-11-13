module RailsAdmin
	module ApplicationHelper
		def get_network_devices
	    network_devices = {}
	    scanner = HttpScanner.new
	    tasmota_addresses = scanner.scan('tasmota')
	    all_ip_addresses = []
	    slaves = SlaveSwitch.all
	    inputs = Input.all
	    switches = Switch.all

	    slaves.each do |slave|
	      all_ip_addresses << slave.ip_address
	    end

	    inputs.each do |input|
	      all_ip_addresses << input.ip_address
	    end

	    switches.each do |switch|
	      all_ip_addresses << switch.ip_address
	    end

	    tasmota_addresses = tasmota_addresses - all_ip_addresses

	    tasmota_addresses.each do |ip|
	      network_devices[get_device_topic(ip)] = ip 
	    end

	    return network_devices
	  end

	  def get_device_topic(ip)
	    JSON.parse(HTTP.get("http://#{ip}/cm?cmnd=status+0").body.to_str)["Status"]["Topic"]
	  end
	end

	module Config
	    module Actions
			class CustomActionTemplate < RailsAdmin::Config::Actions::Base
		        register_instance_option :pjax? do
		          false
		        end

		        register_instance_option :root? do
		          true
		        end
			end

			class ScanNetwork < CustomActionTemplate
		        RailsAdmin::Config::Actions.register(self)

		        register_instance_option :http_methods do
		          [:get]
		        end

		        register_instance_option :controller do
		          proc do
		            NetworkDevice.delete_all
		            @devices = get_network_devices

		            @devices.each do |topic, ip|
		            	NetworkDevice.create(topic: topic, ip_address: ip)
		            end
		            
		            redirect_to dashboard_path
		          end
		        end
		    end
		end
	end
end