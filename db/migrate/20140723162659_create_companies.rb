class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.integer :gen_rank
      t.integer :ren_rank
      t.integer :apt_rank
      t.integer :house_rank
      t.string :p2c_rating
      t.string :p2c_rating_site
      t.string :bbb_grade
      t.string :bbb_grade_site

      t.timestamps
    end
  end
end
