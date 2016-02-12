class Company < ActiveRecord::Base
  
  def self.import(file)
    Company.destroy_all
    CSV.foreach(file.path, headers: true) do |row|
      @import_source_line = (row.to_hash)
      puts "------Source Line: " + @import_source_line.to_s
      @company_row = Company.new
      @company_row.company_name_ptc = "#{@import_source_line['Company_(PTC)']}"
      @company_row.company_name = "#{@import_source_line['Company_(site)']}"
      @company_row.tdu_name = "#{@import_source_line['TDU']}"
      @company_row.p2c_rating = "#{@import_source_line['Power_To_Choose_Rating']}"      
      @company_row.bbb_grade = "#{@import_source_line['BBB_Rating']}"
      @company_row.url_main = "#{@import_source_line['URL']}"
      @company_row.phone = "#{@import_source_line['Phone']}"
      @company_row.gen_kwh_cost_500 = "#{@import_source_line['kWh_cost_@_500_kWh']}"
      @company_row.gen_kwh_cost_1000 = "#{@import_source_line['kWh_cost_@_1000_kWh']}"
      @company_row.gen_kwh_cost_2000 = "#{@import_source_line['kWh_cost_@_2000_kWh']}"
      @company_row.gen_plan_name = "#{@import_source_line['Plan_Name']}"
      @company_row.gen_url_enroll = "#{@import_source_line['Enroll_URL']}"
      @company_row.gen_rank = "#{@import_source_line['General Rank']}"
      @company_row.ren_kwh_cost_500 = "#{@import_source_line['ren_kWh_cost_@_500_kWh']}"
      @company_row.ren_kwh_cost_1000 = "#{@import_source_line['ren_kWh_cost_@_1000_kWh']}"
      @company_row.ren_kwh_cost_2000 = "#{@import_source_line['ren_kWh_cost_@_2000_kWh']}"
      @company_row.ren_plan_name = "#{@import_source_line['ren_Plan_Name']}"
      @company_row.ren_url_enroll = "#{@import_source_line['ren_Enroll_URL']}"      
      @company_row.ren_rank = "#{@import_source_line['Renewable rank']}"
      @company_row.bbb_grade_site = "#{@import_source_line['bbb_url']}"
      @company_row.p2c_rating_site = "#{@import_source_line['Power_to_choose_url']}"
      @company_row.yotpo_id = "#{@import_source_line['Yotpo ID']}"
      @company_row.factsheet_url = "#{@import_source_line['Factsheet']}"
      @company_row.gen_ren_percent = "#{@import_source_line['Renewable_%']}"
      @company_row.gen_term = "#{@import_source_line['Term']}"
      @company_row.gen_cancel_fee = "#{@import_source_line['Cancellation_Fee']}"
      @company_row.ren_ren_percent = "#{@import_source_line['ren_Renewable_%']}"
      @company_row.ren_term = "#{@import_source_line['ren_Term']}"  
      @company_row.ren_cancel_fee = "#{@import_source_line['ren_Cancellation_Fee']}"
      @company_row.ptc_url = "#{@import_source_line['Power_to_choose_url']}"
      @company_row.bbb_url = "#{@import_source_line['bbb_url']}"
      @company_row.gen_factsheet_url = "#{@import_source_line['Gen_Factsheet']}"
      @company_row.company_name_proper = "#{@import_source_line['company_name_proper']}"
      @company_row.med_house_cost_monthly = "#{@import_source_line['med_house_cost_monthly']}"
      @company_row.med_house_cost_kwh = "#{@import_source_line['med_house_cost_kwh']}"
      @company_row.low_house_cost_monthly = "#{@import_source_line['low_house_cost_monthly']}"
      @company_row.low_house_cost_kwh = "#{@import_source_line['low_house_cost_kwh']}"
      @company_row.high_house_cost_monthly = "#{@import_source_line['high_house_cost_monthly']}"
      @company_row.high_house_cost_kwh = "#{@import_source_line['high_house_cost_kwh']}"
      @company_row.ren_med_house_cost_monthly = "#{@import_source_line['ren_med_house_cost_monthly']}"
      @company_row.ren_med_house_cost_kwh = "#{@import_source_line['ren_med_house_cost_kwh']}"
      @company_row.ren_low_house_cost_monthly = "#{@import_source_line['ren_low_house_cost_monthly']}"
      @company_row.ren_low_house_cost_kwh = "#{@import_source_line['ren_low_house_cost_kwh']}"
      @company_row.ren_high_house_cost_monthly = "#{@import_source_line['ren_high_house_cost_monthly']}"
      @company_row.ren_high_house_cost_kwh = "#{@import_source_line['ren_high_house_cost_kwh']}"
      @company_row.company_description = "#{@import_source_line['company_description']}"
      @company_row.logo_image = "#{@import_source_line['logo_image']}"
      @company_row.postal_state = "#{@import_source_line['company_state']}"

      puts "------Company Row: " + @company_row.inspect
      @company_row.save!
      
    end
  end
end
 