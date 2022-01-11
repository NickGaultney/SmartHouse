module RailsAdmin
	module ApplicationHelper
		def get_network_devices
	    network_devices = {}
	    scanner = HttpScanner.new
	    tasmota_addresses = scanner.scan('tasmota')


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

		    class Settings < CustomActionTemplate
		        RailsAdmin::Config::Actions.register(self)

		        register_instance_option :http_methods do
		          [:get]
		        end

		        register_instance_option :controller do
		          proc do
		          end
		        end
		    end

		    class UploadFloorPlan < CustomActionTemplate
				RailsAdmin::Config::Actions.register(self)

				register_instance_option :visible? do
					false
				end

				register_instance_option :show_in_navigation do
					false
				end

				register_instance_option :http_methods do
					[:post]
				end

				register_instance_option :controller do
					proc do
					    uploaded_io = params[:image]

					    File.open(Rails.root.join('public', 'settings', 'floor_plan.png'), 'wb') do |file|
							file.write(uploaded_io.read)
					    end
					    flash[:notice] = "Upload Complete." 
					    
					    respond_to do |format|
					    	format.html { redirect_to dashboard_path, notice: 'Upload Complete.' }
					    	format.js { render js: 'window.top.location.reload(true);' }
					    end
					end
				end
			end
		end
	end
end