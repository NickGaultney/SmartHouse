require 'net/http'

class ButtonsController < ApplicationController
  before_action :set_button, only: [:show, :edit, :update, :destroy, :toggle]

  # GET /buttons
  # GET /buttons.json
  def index
    @buttons = Button.all
  end

  # GET /buttons/1
  # GET /buttons/1.json
  def show
    toggle_switch(Device.find(@button.device_id))
    redirect_to root_path
  end

  def toggle
    toggle_switch(Device.find(@button.device_id))
    redirect_to :back
  end

  # GET /buttons/new
  def new
    @button = Button.new
  end

  # GET /buttons/1/edit
  def edit
  end

  # POST /buttons
  # POST /buttons.json
  def create
    @button = Button.new(button_params)

    respond_to do |format|
      if @button.save
        format.html { redirect_to @button, notice: 'Button was successfully created.' }
        format.json { render :show, status: :created, location: @button }
      else
        format.html { render :new }
        format.json { render json: @button.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buttons/1
  # PATCH/PUT /buttons/1.json
  def update
    @button.update(button_params)
  end

  # DELETE /buttons/1
  # DELETE /buttons/1.json
  def destroy
    @button.destroy
    respond_to do |format|
      format.html { redirect_to buttons_url, notice: 'Button was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_button
      @button = Button.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def button_params
      params.require(:button).permit(:name, :coordinates, :device)
    end

    def toggle_switch(device)
      client = PahoMqtt::Client.new({host: "192.168.1.96", port: 1883, ssl: false, username: 'homeiot', password: '12345678'})
      
      ### Register a callback for puback event when receiving a puback
      waiting_puback = true
      client.on_puback do
        waiting_puback = false
        puts "Message Acknowledged"
      end

      begin 
        client.connect("192.168.1.96", 1883)
      rescue PahoMqtt::Exception
        #Rails.logger.info "Failed to connect to #{device.ip_address}: is #{device.name} online?"
      else
        #Rails.logger.info "Successfully connected to #{device.ip_address}"
        client.publish("cmnd/#{device.id.to_s + "_" + device.name.to_s.gsub(/[\s]/, "_")}/Power", "toggle", false, 1)

        while waiting_puback do
          sleep 0.001
        end

        client.disconnect
      end
    end
end
