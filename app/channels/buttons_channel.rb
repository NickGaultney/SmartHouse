class ButtonsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'buttons'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
