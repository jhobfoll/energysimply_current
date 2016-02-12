class PaypalController < ApplicationController

  
    def paypal_success

      @transaction = Transaction.new(:user_id => current_user.id, 
                                     :payment_service => "Paypal", 
                                     :trans_type => "Recurring",
                                     :paypal_auth => params[:auth])
      unless @transaction.save
        puts "Our Transaction Did Not Save on Paypal Success"
      end
      
      redirect_to submit_bill_path, :notice => "Paypal Transaction Successful."
      
    end
    
    
    def paypal_failure
      
      @transaction = Transaction.new(:user_id => current_user.id, 
                                     :payment_service => "Paypal", 
                                     :trans_type => "Failed"
                                     )
      unless @transaction.save
        puts "Our Transaction Did Not Save on Paypal Fail"
      end
      
       redirect_to payment_path, :notice => "Paypal Transaction Failed - Please Try Again."
       
    end
    
    
    def paypal_notify
      
      # We should get some data about the payment sent to this path.
      
      # in an 'open-code' button, adding the following would do this:
      # <input name="notify_url" value="/paypal/notify" type="hidden">
      
      # As we are using a hidden-code button, we will need to re-do the button-creation
      # on the paypal site with the following in the 'extra variables' option:
      #notify_url=http://www.energysimpl.y/paypal/notify
      
      # For Now, let's just put what was submitted into our log and see what of it we can use:
      puts "------PayPal Sent To Notify: " + params.inspect
       
    end

    
    def paypal_params
      params.require(:transaction).permit(:paypal_auth)
    end

end