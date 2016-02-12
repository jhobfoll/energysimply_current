class AddColumnsToCompanies4 < ActiveRecord::Migration
  def change
  	add_column :companies, :med_house_cost_monthly, :integer
  	add_column :companies, :med_house_cost_kwh, :decimal
  	add_column :companies, :low_house_cost_monthly, :integer
  	add_column :companies, :low_house_cost_kwh, :decimal
  	add_column :companies, :high_house_cost_monthly, :integer
  	add_column :companies, :high_house_cost_kwh, :decimal  	
  	add_column :companies, :ren_med_house_cost_monthly, :integer
  	add_column :companies, :ren_med_house_cost_kwh, :decimal
  	add_column :companies, :ren_low_house_cost_monthly, :integer
  	add_column :companies, :ren_low_house_cost_kwh, :decimal
  	add_column :companies, :ren_high_house_cost_monthly, :integer
  	add_column :companies, :ren_high_house_cost_kwh, :decimal
  end
end