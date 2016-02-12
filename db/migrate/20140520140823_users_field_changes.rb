class UsersFieldChanges < ActiveRecord::Migration
  def change
    add_column :users, :bill_send_method, :string
    rename_column :users, :address_1, :billing_address_1
    rename_column :users, :address_2, :billing_address_2
    add_column :users, :billing_city, :string
    add_column :users, :billing_state, :string
    add_column :users, :billing_zip, :string
  end
end
