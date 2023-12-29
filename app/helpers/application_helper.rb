module ApplicationHelper

  def current_cart
  	if !session[:cart_id].nil?
  		Cart.find(session[:cart_id])
	else
		Cart.new
  	end
  end

  def format_time_duration(duration)
    hours = (duration / 1.hour).to_i
    minutes = ((duration % 1.hour) / 1.minute).to_i
    seconds = ((duration % 1.minute) / 1.second).to_i

    "#{format('%02d', hours)}:#{format('%02d', minutes)}:#{format('%02d', seconds)}"
  end
  # Update the format_time_duration method in your Ruby code
# def format_time_duration(duration)
#   days = (duration / 1.day).to_i
#   hours = ((duration % 1.day) / 1.hour).to_i
#   minutes = ((duration % 1.hour) / 1.minute).to_i
#   seconds = ((duration % 1.minute) / 1.second).to_i

#   "#{days}d #{format('%02d', hours)}h #{format('%02d', minutes)}m #{format('%02d', seconds)}s"
# end

end
