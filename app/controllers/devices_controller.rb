class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy, :bump]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  def bump
    ActionCable.server.broadcast(
      'buttons',
      state: @device.state,
      id: @device.id
    )

    head :ok
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    @device.update(device_params)
    head :ok
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scan
    scanner = HttpScanner.new
    tasmota_addresses = scanner.scan('tasmota')

    @ip_addresses = tasmota_addresses - getAllIP
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def device_params
      params.require(:device).permit(:name, :ip_address)
    end

    def getAllIP
      all_ip_addresses = []
      devices = Device.all

      devices.each do |device|
        all_ip_addresses << device.ip_address
      end

      return all_ip_addresses
    end
end
