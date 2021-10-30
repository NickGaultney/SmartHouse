class SwitchesController < ApplicationController
	before_action :set_switch, only: [:update, :show, :bump]

	def bump
	    ActionCable.server.broadcast(
	      'buttons',
	      state: @switch.state,
	      id: @switch.id
	    )

	    head :ok
  	end

  	def show
  		WTMQTT.toggle_light(@switch.topic)
  		redirect_to root_path
  	end

  	def update
	    @switch.update(switch_params)
	    head :ok
  	end

  	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_switch
	      @switch = Switch.find(params[:id])
	    end

	    # Only allow a list of trusted parameters through.
	    def switch_params
	      params.require(:switch).permit(:name, :topic, :ip_address, :state, :coordinates)
	    end
end
