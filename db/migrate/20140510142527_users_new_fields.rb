class UsersNewFields < ActiveRecord::Migration
  def change
    remove_column :users, :name
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :zip_id, :string
  end
end
