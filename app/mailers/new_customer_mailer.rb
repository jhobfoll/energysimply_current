class NewCustomerMailer < ActionMailer::Base
  default from: "Jordan Hobfoll <admin@energysimp.ly>"

  def new_customer_signup_greeting_basic(customer_object, plain_pass)
    @customer = customer_object # for passing to view / mailer-text
    @plain_pass = plain_pass
    puts ">>>>>>>>>>Plain Pass in Mailer: " + @plain_pass
    mail(:to => customer_object.email, :subject => "Welcome to Energy Simply")
  end

  def new_customer_signup_greeting_gold(customer_object, plain_pass)
    @customer = customer_object # for passing to view / mailer-text
    @plain_pass = plain_pass
    puts ">>>>>>>>>>Plain Pass in Mailer: " + @plain_pass
    mail(:to => customer_object.email, :subject => "Welcome to Energy Simply")
  end

  def new_customer_signup_greeting_not_yet_served(customer_object, plain_pass)
    @customer = customer_object # for passing to view / mailer-text
    @plain_pass = plain_pass
    puts ">>>>>>>>>>Plain Pass in Mailer: " + @plain_pass
    mail(:to => customer_object.email, :subject => "Welcome to Energy Simply")
  end


end #class
