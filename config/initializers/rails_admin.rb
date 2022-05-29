require Rails.root.join('lib', 'rails_admin', 'scan_network.rb')

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    scan_network
    settings
    upload_floor_plan
    icon_upload
    network_monitor

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model Event do
    edit do
      field :enabled
      field :days_to_repeat do
        def render
          if bindings[:object].days_to_repeat.present?
            current_days = parse_days(bindings[:object].days_to_repeat)
            days_to_repeat = bindings[:object].days_to_repeat
          else
            days_to_repeat = ""
            current_days = {sunday: "", monday: "", tuesday: "", wednesday: "", thursday: "", friday: "", saturday: ""}
          end

          bindings[:view].render partial: 'days_of_week', :locals => {:field => self, :form => bindings[:form], days_to_repeat: days_to_repeat, current_days: current_days }
        end
      end
      field :start_date
      field :end_date
      field :time
      field :action do
        def render
          bindings[:view].render partial: 'subtypes', :locals => {:field => self, :form => bindings[:form], field_name: "action", model_name: "event", current_type: bindings[:object].action, subtypes: ["on", "off", "toggle"]}
        end
      end
      field :input
    end
  end

  config.model TasmotaConfig do
    edit do
      field :name
      field :gpio
      field :switch_state
    end
  end

  config.model Button do
    edit do
      field :icon
      field :buttonable
    end
  end

  config.model Icon do
    edit do
      field :name do
        def render
          bindings[:view].render partial: 'icon_upload', :locals => {:field => self, :form => bindings[:form]}
        end
      end
    end
  end

  config.model IoDevice do
    edit do
      field :name
      field :ip_address do
        def render
          if bindings[:object].ip_address.present?
            devices = {bindings[:object].topic => bindings[:object].ip_address}
          else
            devices = get_network_devices
          end

          bindings[:view].render partial: 'io_device_ip_address', :locals => {:field => self, :form => bindings[:form], current_ip: bindings[:object].ip_address, network_devices: devices}
        end
      end
      field :device_type do
        def render
          bindings[:view].render partial: 'subtypes', :locals => {:field => self, :form => bindings[:form], field_name: "device_type", model_name: "io_device", current_type: bindings[:object].device_type, subtypes: IoDevice.subclasses.map(&:name)}
        end
      end
      field :tasmota_config
    end
  end

  config.model Input do
    edit do
      field :name
      field :switch_mode do
        def render
          modes = ["toggle", "follow"]
          bindings[:view].render partial: 'subtypes', :locals => {:field => self, :form => bindings[:form], field_name: "switch_mode", model_name: "input", current_type: bindings[:object].switch_mode, subtypes: modes}
        end
      end
      field :input_type do
        def render
          bindings[:view].render partial: 'subtypes', :locals => {:field => self, :form => bindings[:form], field_name: "input_type", model_name: "input", current_type: bindings[:object].input_type, subtypes: Input.subclasses.map(&:name)}
        end
      end
      field :io_device
      field :groups
      field :outputs
    end
  end

  config.model Output do
    edit do
      field :name
      field :output_type do
        def render
          bindings[:view].render partial: 'subtypes', :locals => {:field => self, :form => bindings[:form], field_name: "output_type", model_name: "output", current_type: bindings[:object].output_type, subtypes: Output.subclasses.map(&:name)}
        end
      end
      field :io_device
    end
  end

  config.model Group do
    edit do
      field :name
      field :outputs
    end
  end

  config.model NodeMcu do
    visible do
      false
    end
  end

  config.model Esp32 do
    visible do
      false
    end
  end

  config.model SonoffMiniR2 do
    visible do
      false
    end
  end

  config.model RemoteSwitch do
    visible do
      false
    end
  end

  config.model MagneticSwitch do
    visible do
      false
    end
  end

  config.model Switch do
    visible do
      false
    end
  end

  config.model VirtualSwitch do
    visible do
      false
    end
  end

  config.model Relay do
    visible do
      false
    end
  end
=begin
  config.model Switch do
    edit do
      field :name
      field :ip_address do
        def render
          if bindings[:object].ip_address.present?
            devices = {bindings[:object].topic => bindings[:object].ip_address}
          else
            devices = get_network_devices
          end

          bindings[:view].render partial: 'switch_ip_address', :locals => {:field => self, :form => bindings[:form], network_devices: devices}
        end
      end
    end
  end

  config.model SlaveSwitch do
    edit do
      field :name
      field :ip_address do
        def render
          if bindings[:object].ip_address.present?
            devices = {bindings[:object].topic => bindings[:object].ip_address}
          else
            devices = get_network_devices
          end

          bindings[:view].render partial: 'slave_switch_ip_address', :locals => {:field => self, :form => bindings[:form], network_devices: devices}
        end
      end
      field :switch
      field :switch_mode do
        def render
          bindings[:view].render partial: 'switch_mode', :locals => {:field => self, :form => bindings[:form], current_mode: bindings[:object].switch_mode}
        end
      end
      field :enable_relay
    end
  end
  
  config.model Input do
    edit do
      field :name
      field :ip_address do
        def render
          if bindings[:object].ip_address.present?
            devices = {bindings[:object].topic => bindings[:object].ip_address}
          else
            devices = get_network_devices
          end
        
        bindings[:view].render partial: 'input_device_ip_address', :locals => {:field => self, :form => bindings[:form], network_devices: devices}
        end
      end
    end
  end
=end

  config.model NetworkDevice do
    visible do
      false
    end
  end

  def get_network_devices
    network_devices = {}
    NetworkDevice.all.each do |device|
      network_devices[device.topic] = device.ip_address
    end

    return network_devices
  end

  def parse_days(days_to_repeat)
    days = {}
    
    days_temp = days_to_repeat.split(",")

    days[:sunday] = days_temp[0] == "1" ? "checked=checked" : ""
    days[:monday] = days_temp[1] == "1" ? "checked=checked" : ""
    days[:tuesday] = days_temp[2] == "1" ? "checked=checked" : ""
    days[:wednesday] = days_temp[3] == "1" ? "checked=checked" : ""
    days[:thursday] = days_temp[4] == "1" ? "checked=checked" : ""
    days[:friday] = days_temp[5] == "1" ? "checked=checked" : ""
    days[:saturday] = days_temp[6] == "1" ? "checked=checked" : ""

    return days
  end
end