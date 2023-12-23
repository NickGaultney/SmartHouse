class Api::V1::ApiController < ApplicationController
	before_action :set_light, only: [:show, :update]

	def index
		lights = Output.where(output_type: "Relay")
		render json: lights
	end

	def show
		render json: @light 
	end

	def update
		render json: @light.update(light_params)
		@light.switch_action params["state"]
	end

	def webhook
		
	end

	private
		# Use callbacks to share common setup or constraints between actions.
	    def set_light
	      @light = Output.find(params[:id])
	    end

	    # Only allow a list of trusted parameters through.
	    def light_params
	      params.require(:output).permit(:name, :nickname, :state)
	    end

end