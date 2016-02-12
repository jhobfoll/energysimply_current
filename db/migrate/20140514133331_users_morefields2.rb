class UsersMorefields2 < ActiveRecord::Migration
  def change
    add_column :users, :middle_initial, :string
    add_column :users, :maiden_name, :string
    add_column :users, :service_type, :string
    add_column :users, :plan_type, :string    
    add_column :users, :dwelling_type, :string
    add_column :users, :svc_new_old, :string
    add_column :users, :move_in_date, :date
    add_column :users, :home_new_old, :string
    add_column :users, :meter_type, :string
    add_column :users, :rewired, :string
    add_column :users, :mobile, :string
    add_column :users, :sq_ft_range, :int
    add_column :users, :dob, :string
    add_column :users, :encrypted_ssnum, :string    
    add_column :users, :payment_info_id, :int
    add_column :users, :admin, :boolean, :default => false
  end
end
