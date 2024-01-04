class MessagesController < ApplicationController
	def send_sms
        phone_number = '+917987781031' # Replace with recipient's phone number
        message = 'Hello from Twilio and Rails!'
        
        TwilioService.send_sms(phone_number, message)
        
        flash[:success] = 'SMS sent successfully!'
        redirect_to root_path
    end
end
