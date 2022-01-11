class ButtonsController < ApplicationController
	before_action :set_button, only: [:update, :show, :bump]

	def bump
		state = get_state
	    ActionCable.server.broadcast(
	      'buttons',
	      state: get_state,
	      id: @button.id
	    )

	    head :ok
  	end

  	def show
  		@button.buttonable.buttonable_action
  		#Rails.logger.info @button.buttonable.name
  		redirect_to root_path
  	end

  	def update
	    @button.update(button_params)
	    head :ok
  	end

  	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_button
	      @button = Button.find(params[:id])
	    end

	    # Only allow a list of trusted parameters through.
	    def button_params
	      params.require(:button).permit(:coordinates, :icon, :buttonable_type, :buttonable_id)
	    end

	    def get_state
	    	@button.buttonable.respond_to?(:state) ? @button.buttonable.state : false
	    end
end
