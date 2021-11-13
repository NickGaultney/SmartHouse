class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generate_topic(record)
    record.class.to_s + "_" + record.id.to_s + "_" + record.name.to_s.gsub(/[\s]/, "_")
  end
end
