class AddColumnToBillTable < ActiveRecord::Migration
  def change
  	add_column :bills, :bill_month, :string	  	
  end
end
