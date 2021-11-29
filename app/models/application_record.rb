class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generate_topic(record)
    record.name.to_s.gsub(/[\s]/, "_") + "_" + record.id.to_s + "_" + record.class.to_s
  end

  def remove_network_device(ip)
    NetworkDevice.find_by(ip_address: ip).destroy
  end
end
