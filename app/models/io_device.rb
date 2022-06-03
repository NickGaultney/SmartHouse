class IoDevice < ApplicationRecord
  self.inheritance_column = "device_type"

  has_many :inputs, dependent: :destroy
  has_many :outputs, dependent: :destroy
  belongs_to :tasmota_config

  before_save :update_topic, if: :will_save_change_to_name?
  after_create :setup_device
  after_update :update_device

  def update_topic
    self.topic = generate_topic(self)

  end
  
  def setup_device
    self.update(topic: generate_topic(self))

    Device.new(device: self.device_type.constantize.find(self.id)).initialize_device
    remove_network_device(self.ip_address)
    self.device_type.constantize.find(self.id).generate_io if self.device_type
  end

  def update_device
    Device.new(device: self.device_type.constantize.find(self.id)).initialize_device
  end

  def generate_io

  end

  def gpio_template

  end

  def tasmota_rules

  end
end
