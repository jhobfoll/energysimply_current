class NewCustomerNotificationMailer < ActionMailer::Base
  default from: "admin@energysimp.ly"

  def new_customer_notification(customer_object)

    # for passing to view / mailer-text
    @customer = customer_object

    mail(:to => "EspondaPartners@yahoogroups.com",
          :subject => (
                "New Customer Notification" + " - " + @customer.zip.tdu_name)
        )
  end


  def contact_us_notification(first_name, last_name, email, question)

    @first_name = first_name
    @last_name = last_name
    @email = email
    @question = question

    mail( :to => "EspondaPartners@yahoogroups.com",
          :replyto => @email,
          :subject => ("Contact Us Notification")
        )
  end

end #class
