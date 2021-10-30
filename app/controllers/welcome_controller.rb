class WelcomeController < ApplicationController
  def home
    @switches = Switch.all
  end
end
