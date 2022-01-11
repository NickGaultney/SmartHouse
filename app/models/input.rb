class Input < ApplicationRecord
  self.inheritance_column = "input_type"

  belongs_to :io_device, optional: true   
  has_many :buttons, as: :buttonable
  has_and_belongs_to_many :outputs
  has_and_belongs_to_many :groups

  before_save :update_state
  def update_state
    self.state = false if state.nil?
  end

  def buttonable_action
    self.all_outputs.each do |output|
      output.switch_action((self.state ? 1 : 0))
    end
  end

  def all_outputs
    all_outputs = self.outputs

    self.groups.each do |group|
      all_outputs += group.outputs
    end

    return all_outputs
  end
end
