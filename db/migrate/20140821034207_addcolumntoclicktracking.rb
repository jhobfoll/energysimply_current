class Addcolumntoclicktracking < ActiveRecord::Migration
  def change
  	add_column :click_trackings, :ip_address, :string
  end
end
