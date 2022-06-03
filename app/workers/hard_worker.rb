class HardWorker
  include Sidekiq::Worker

  def perform(topic, message)
    WTMQTT.publish do |client|
      #client.publish("cmnd/#{topic}/Power", state, false, 1)
      client.publish(topic, message, false, 1)
    end
  end
end
