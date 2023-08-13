class WelcomeController < ApplicationController
  def home
    @buttons = Button.all
  end

  def reboot
    %x[rake restart_non_rails]
    redirect_to root_path
  end
end
