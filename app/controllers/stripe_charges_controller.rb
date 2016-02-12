class StripeChargesController < ApplicationController

  before_filter :is_admin?, :only => [:stripe_config, :create_plans]

  # The 'new' behavior will take place on our '/users/payment'  controller and view
  #def new
  #end

  # The payment-form for Stripe (clicking the Stripe button), will submit to this method:
  def create
    @new_sign_up = false  #don't call alias again, but do call identify from here on
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    unless ( params[:card].present? && params[:card][:card_number].present? &&
        params[:card][:exp_year].present? && params[:card][:exp_month].present? &&
        params[:card][:cvc].present? && params[:card][:plan_id].present? &&
        params[:phone].present? && params[:customer_card_name].present?
       )

      puts "-----StripeCC - Missing Fields In Form"
      flash.now[:alert] = "Missing Details - All Fields are compulsory"
      @name = params[:customer_card_name]
      @phone = params[:phone]
      render 'users/payment'
      return
    end

 		@error = current_user.create_stripe_subscription(subscription_params)

	 	if @error.present?
	 		flash.now[:alert] = @error
	 		logger.warn("=========Stripe Controller - Transaction Failure=========")
      @transaction = Transaction.new( :user_id => current_user.id,
                                      :payment_service => "Stripe",
                                      :trans_type => "Failed",
                                      :stripe_callback_data => @error
                                    )
      unless @transaction.save
          puts "-----StripeCC - Our Transaction Did Not Save on Stripe Fail"
      end

      # back to payment screen:
	 		render 'users/payment'

	 	else #success
	 		flash.now[:notice] = "Subscription Successfull"
	 		logger.warn("=========Transaction Successfull=========")
      @transaction = Transaction.where(:user_id => current_user.id).order("id DESC").first
      if @transaction.present?
          @transaction.update_attributes(
                                        :payment_service => "Stripe",
                                        :trans_type => "Recurring"
                                      )
      else
        puts "-----StripeCC - Our Transaction Did Not Save on Stripe Success"
      end

      namearray = (params[:customer_card_name]).split(' ', 2)
      save_user = current_user.update_attributes(:phone => (params[:phone]),
        :first_name => namearray.first, :last_name => namearray.last)
      puts ">>> current user did not save email and name."  if save_user == false

	 		redirect_to submit_bill_path, :notice => "Subscription Successful."
	  end

  end


  def stripe_config
  end

  def create_plans

    require "stripe"
    Stripe.api_key = "sk_test_LtokYQwTH0eDyl11GwXwXpWH"
    #Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    begin

      Stripe::Plan.create(
        :amount => 199,
        :interval => 'month',
        :name => 'Basic Plan',
        :currency => 'usd',
        :id => 'basic'
      )

      Stripe::Plan.create(
        :amount => 399,
        :interval => 'month',
        :name => 'Gold Plan',
        :currency => 'usd',
        :id => 'gold'
      )

    rescue
      redirect_to stripe_config_path, :notice => "Error Creating Plans.  Do Plans Already Exist?"
      return
    end

    redirect_to stripe_config_path, :notice => "Plan Creation Completed."

  end


  private

  def subscription_params
    params.require(:card).permit(:email, :card_number,:exp_year, :exp_month, :cvc, :plan_id)
  end


end #class
