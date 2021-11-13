class Switch < ApplicationRecord
	after_create :setup_switch
	before_save :update_switch, if: :will_save_change_to_name?
	
	def setup_switch
		self.update(topic: generate_topic(self), coordinates: "1%,1%", state: false)
		Device.new(device: self, type: "sonoff_mini").initialize_device
	end

	def update_switch
		self.topic = generate_topic(self)
		Device.new(device: self, type: "sonoff_mini").initialize_device
	end
end
