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

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

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
        partial "switch_mode"
      end
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