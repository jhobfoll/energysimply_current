class UsersAddVisitorId < ActiveRecord::Migration
  def change
    add_column :users, :visitor_id, :integer
  end
end
