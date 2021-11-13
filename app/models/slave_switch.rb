class SlaveSwitch < ApplicationRecord
  belongs_to :switch

  after_create :setup_device
  before_save :update_switch

  def setup_device
    self.update(topic: generate_topic(self))
    Device.new(device: self, type: "sonoff_mini").initialize_device
    remove_network_device(self.ip_address)
  end

  def update_switch
    self.topic = generate_topic(self)
    Device.new(device: self, type: "sonoff_mini").initialize_device
  end
end
