class AddCompanyColumns2 < ActiveRecord::Migration
  def change
    add_column :companies, :yotpo_id, :integer
    add_column :companies, :factsheet_url, :string
    add_column :companies, :gen_kwh_cost_500, :string
    add_column :companies, :gen_kwh_cost_2000, :string
    add_column :companies, :ren_kwh_cost_500, :string
    add_column :companies, :ren_kwh_cost_2000, :string
    add_column :companies, :gen_ren_percent, :string
    add_column :companies, :gen_term, :string
    add_column :companies, :gen_cancel_fee, :string
    add_column :companies, :ren_ren_percent, :string
    add_column :companies, :ren_term, :string
    add_column :companies, :ren_cancel_fee, :string
    add_column :companies, :ptc_url, :string
    add_column :companies, :bbb_url, :string
  end
end
