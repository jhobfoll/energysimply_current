class UsersSma < ActiveRecord::Migration
  def change
  	add_column :users, :smart_meter_auth, :string
  end
end
