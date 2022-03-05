class Event < ApplicationRecord
  has_and_belongs_to_many :outputs
  has_and_belongs_to_many :groups

  validates :days_to_repeat, :presence => true
  validates :start_date, :presence => true
  validates :time, :presence => true
  validates :action, :presence => true

  after_create :restart_scheduler
  after_update :restart_scheduler
  after_destroy :restart_scheduler

  def restart_scheduler
    system("screen -X -S scheduler quit")
    sleep(0.5)
    system("screen -dmS scheduler rake scheduler")
  end

  def days
    convert_to_array = self.days_to_repeat.split(",")
    days = [] 
    convert_to_array.each do |day|
      days << (day == "1" ? true : false)
    end

    return days
  end

  def start_date_time
    self.start_date.to_time
  end

  def end_date_time
    self.end_date.to_time
  end

  def time
    now = Time.now
    Time.new(now.year, now.month, now.day, super.hour, super.min, super.sec)
  end

  def is_after(hour, minutes)
    if self.time.hour > hour 
      return true
    elsif self.time.hour == hour
      return self.time.min > minutes ? true : false
    else
      return false
    end
  end

  def time_in_seconds
    now = Time.now
    beginning_of_today = now.to_date.to_time

    if now <= time
      return time - now
    else
      return time - beginning_of_today 
    end
  end

  def all_outputs
    all_outputs = self.outputs

    self.groups.each do |group|
      all_outputs += group.outputs
    end

    return all_outputs
  end

  def foreach_output
    self.all_outputs.each do |output|
      yield(output)
    end
  end
end