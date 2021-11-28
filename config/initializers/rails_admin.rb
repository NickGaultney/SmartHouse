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

    ## With an audit adapter, you can add:
    # history_index
    # history_show
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
end