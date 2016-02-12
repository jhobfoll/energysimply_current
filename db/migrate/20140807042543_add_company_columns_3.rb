class AddCompanyColumns3 < ActiveRecord::Migration
  def change
  	add_column :companies, :gen_factsheet_url, :string
  	add_column :companies, :company_name_proper, :string
  end
end