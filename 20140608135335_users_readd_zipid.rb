class UsersReaddZipid < ActiveRecord::Migration
  def change
	add_column :users, :zip_id, :integer
  end
end
