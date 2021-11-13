class Input < ApplicationRecord

	after_create :setup_device
	before_save :update_input
	def setup_device
		self.update(topic: generate_topic(self))
		
		Device.new(device: self, type: "node_mcu").initialize_device
	end

	def update_input
		self.topic = generate_topic(self)
	    Device.new(device: self, type: "node_mcu").initialize_device
	end
end
