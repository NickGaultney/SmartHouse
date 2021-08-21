require 'net/http'

class ButtonsController < ApplicationController
  before_action :set_button, only: [:show, :edit, :update, :destroy]

  # GET /buttons
  # GET /buttons.json
  def index
    @buttons = Button.all
  end

  # GET /buttons/1
  # GET /buttons/1.json
  def show
    toggle_switch(Device.find(@button.device_id))
    head :no_content
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
    respond_to do |format|
      if @button.update(button_params)
        format.html { redirect_to @button, notice: 'Button was successfully updated.' }
        format.json { render :show, status: :ok, location: @button }
      else
        format.html { render :edit }
        format.json { render json: @button.errors, status: :unprocessable_entity }
      end
    end
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
      uri = URI("http://#{device.ip_address}/?relay=toggle")
      Net::HTTP.get(uri)
    end
end
