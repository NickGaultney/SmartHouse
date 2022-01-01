class HardWorker
  include Sidekiq::Worker

  def perform(topic, state)
    WTMQTT.publish do |client|
      client.publish("cmnd/#{topic}/Power", state, false, 1)
    end
  end
end
