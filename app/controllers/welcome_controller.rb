class WelcomeController < ApplicationController
  def home
    @buttons = Button.all
  end
end
