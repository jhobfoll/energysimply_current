class UsersReaddZipid < ActiveRecord::Migration
  def change
  	add_column :users, :zip_id, :integer
  	add_column :users, :plan_grade, :string
  end
end
