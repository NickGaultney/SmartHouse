class InputsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'inputs'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
