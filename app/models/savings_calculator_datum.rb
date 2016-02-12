class SavingsCalculatorDatum < ActiveRecord::Base

  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true,
      :header_converters=> lambda {|f| f.strip},
      :converters=> lambda {|f| f ? f.strip : nil}
     ) do |row|

      tdu_data_hash = row.to_hash
      puts ">>>>>>>>>>>tdu_data_hash: " + tdu_data_hash.to_s
      # Convert exising headers in CSV to col-names in DB
      tdu_data_hash[:idKey] = tdu_data_hash.delete("[idKey]")
      tdu_data_hash[:TduCompanyName] = tdu_data_hash.delete("[TduCompanyName]")
      tdu_data_hash[:RepCompany] = tdu_data_hash.delete("[RepCompany]")
      tdu_data_hash[:Product] = tdu_data_hash.delete("[Product]")
      tdu_data_hash[:Renewable] = tdu_data_hash.delete("[Renewable]")
      tdu_data_hash[:TermValue] = tdu_data_hash.delete("[TermValue]")
      tdu_data_hash[:rate_100] = tdu_data_hash.delete("100")
      tdu_data_hash[:rate_500] = tdu_data_hash.delete("500")
      tdu_data_hash[:rate_1000] = tdu_data_hash.delete("1000")
      tdu_data_hash[:rate_2000] = tdu_data_hash.delete("2000")
      tdu_data_hash[:rate_500_fixed] = tdu_data_hash.delete("500_fixed")
      tdu_data_hash[:rate_1000_fixed] = tdu_data_hash.delete("1000_fixed")
      tdu_data_hash[:rate_2000_fixed] = tdu_data_hash.delete("2000_fixed")
      tdu_data_hash[:Promo_adj] = tdu_data_hash.delete("Promo adj")

      tdu_data = SavingsCalculatorDatum.where(idKey: tdu_data_hash["idKey"]).first

      if tdu_data.present?
        puts "Row: " + tdu_data_hash.to_s
        tdu_data.update_attributes(tdu_data_hash)
      else # make new record
        SavingsCalculatorDatum.create!(tdu_data_hash)
      end

    end # end CSV.foreach
  end # end class method import

end
