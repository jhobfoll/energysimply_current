class UsersRemoveZipid < ActiveRecord::Migration
  def change
    remove_column :users, :zip_id
  end
end
