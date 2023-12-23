class Input < ApplicationRecord
  self.inheritance_column = "input_type"

  belongs_to :io_device, optional: true   
  has_many :buttons, as: :buttonable
  has_and_belongs_to_many :outputs
  has_and_belongs_to_many :groups

  before_save :update_state
  before_save :update_switch_mode, if: :will_save_change_to_switch_mode?

  def update_state
    self.state = false if state.nil?
  end

  def update_switch_mode
    mode = 0
    case self.switch_mode
      when 'toggle'
        mode = 0
      when 'follow'
        mode = 1
      when 'inverted-follow'
        mode = 2
    end
    
    self.io_device.update_switch_mode(mode)
  end

  def buttonable_action
    Rails.logger.info "##########################{self.switch_mode}######################"
    case self.switch_mode
    when 'toggle'
      toggle
    when 'follow'
      foreach_output {|output| output.switch_action((self.state ? 1 : 0)) }
    when 'inverted-follow'
      foreach_output {|output| output.switch_action((self.state ? 0 : 1)) }
    end
  end

  def all_outputs
    all_outputs = self.outputs

    self.groups.each do |group|
      all_outputs += group.outputs
    end

    return all_outputs
  end

  def on
    foreach_output {|output| output.switch_action(1)}
  end

  def off
    foreach_output {|output| output.switch_action(0)}
  end

  def toggle
    foreach_output {|output| output.switch_action(2)}
  end

  private
    def foreach_output
      self.all_outputs.each do |output|
        yield(output)
      end
    end
end
