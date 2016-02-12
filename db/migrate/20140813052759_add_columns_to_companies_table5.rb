class AddColumnsToCompaniesTable5 < ActiveRecord::Migration
  def change
  	add_column :companies, :company_description, :text	  	
  end
end
