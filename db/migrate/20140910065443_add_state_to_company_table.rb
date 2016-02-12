class AddStateToCompanyTable < ActiveRecord::Migration
  def change
  	add_column :companies, :postal_state, :string	  	
  end
end
