class ZipsTable < ActiveRecord::Migration
  def change
    create_table :zips do |t|
      t.string :zip
      t.string :city
      t.string :state
      t.string :postal_state
      t.string :landing_page

      t.timestamps
    end
  end
end
