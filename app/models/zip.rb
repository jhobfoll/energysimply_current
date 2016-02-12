class Zip < ActiveRecord::Base
  #attr_accessible :city, :postal_state, :state, :zip, :landing_page, 
      # :tdu_name, :tdu_id
  
  belongs_to :tdu
  
  def self.set_tdu_id
    Zip.all.each do |z|
      case z.tdu_name
             
      when "AEP TEXAS CENTRAL COMPANY"
        z.tdu_id = 1
            
      when "AEP TEXAS NORTH COMPANY"
        z.tdu_id = 2
      
      when "CENTERPOINT ENERGY HOUSTON ELECTRIC LLC"
        z.tdu_id = 3
      
      when "ONCOR ELECTRIC DELIVERY COMPANY"
        z.tdu_id = 4
      
      when "SHARYLAND UTILITIES LP"
        z.tdu_id = 5
      
      when "SHARYLAND UTILITIES LP - MCALLEN"
        z.tdu_id = 6
      
      when "TEXAS-NEW MEXICO POWER COMPANY"
        z.tdu_id = 7

      when "COMMONWEALTH EDISON"
        z.tdu_id = 8     
      # no else - leave null
      
      end #case
      
      unless z.save
        puts "Error Saving Zip tdu_id for: " + z.zip.to_s
      end # unless save

    end # each do
  end #def
  
  
end

