class EmailRefMailer < ActionMailer::Base
  default from: "admin@energysimp.ly"
  
  def email_ref_greeting(email_ref, referred_by)
    
    # for passing to view / mailer-text
    @email_ref = email_ref
    @referrer = referred_by 
    
    mail(:to => email_ref.email, 
          :subject => ( 
                referred_by.first_name + " " + referred_by.last_name + 
                " Referred You To Energy Simply") 
        )
  end
  

  
  
end #class
