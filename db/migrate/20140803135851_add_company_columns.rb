class AddCompanyColumns < ActiveRecord::Migration
  def change
    add_column :companies, :company_name_ptc, :string
    add_column :companies, :phone, :string
    add_column :companies, :url_main, :string
    add_column :companies, :tdu_name, :string
    add_column :companies, :gen_plan_name, :string
    add_column :companies, :ren_plan_name, :string
    add_column :companies, :gen_url_enroll, :string
    add_column :companies, :ren_url_enroll, :string
    add_column :companies, :gen_kwh_cost_1000, :string
    add_column :companies, :ren_kwh_cost_1000, :string
  end
end
