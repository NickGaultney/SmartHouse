class SonoffMiniR2 < IoDevice
	def generate_io
		Input.create(name: "#{self.name}_SMR2_#{self.id}_in", input_type: "Switch", io_device: self)
		Output.create(name: "#{self.name}_SMR2_#{self.id}_out", output_type: "Relay", io_device: self)
	end
end