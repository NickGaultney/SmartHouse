module ApplicationHelper
	def alert_class(flash_type)
		case flash_type.to_sym
			when :notice then "alert alert-info"
	        when :success then "alert alert-success"
	        when :error then "alert alert-danger"
	        when :alert then "alert alert-danger"
    	end
	end
end