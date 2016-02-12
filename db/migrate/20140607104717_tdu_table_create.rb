class TduTableCreate < ActiveRecord::Migration
  def change
    create_table :tdus do |t|
      t.string :name
      t.integer :apt_avg
      t.integer :apt_best
      t.integer :house_avg
      t.integer :house_best

      t.timestamps
    end
  end
end
