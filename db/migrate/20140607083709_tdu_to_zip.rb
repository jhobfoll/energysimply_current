class TduToZip < ActiveRecord::Migration
  def change
    add_column :zips, :tdu_name, :string
    add_column :zips, :tdu_id, :integer
  end
end
