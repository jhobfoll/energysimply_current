class VisitorsAddEmail < ActiveRecord::Migration
  def change
      add_column :visitors, :email, :string	  	
  end
end
