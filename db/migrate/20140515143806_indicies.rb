class Indicies < ActiveRecord::Migration
  def change
    add_index :zips, :zip, :unique => true
  end
end
