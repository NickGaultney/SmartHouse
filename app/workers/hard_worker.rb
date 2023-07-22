class HardWorker
  include Sidekiq::Worker

  def perform(topic, message)
    WTMQTT.publish(topic, message)
  end
end
