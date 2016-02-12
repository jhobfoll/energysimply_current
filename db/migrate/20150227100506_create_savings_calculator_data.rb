class CreateSavingsCalculatorData < ActiveRecord::Migration
  def change
    create_table :savings_calculator_data do |t|
      t.integer :idKey
      t.string :TduCompanyName
      t.string :RepCompany
      t.string :Product
      t.integer :Renewable
      t.integer :TermValue
      t.decimal :Promo_adj, precision: 8, scale: 2
      t.decimal :rate_100, precision: 8, scale: 4
      t.decimal :rate_500, precision: 8, scale: 4
      t.decimal :rate_1000, precision: 8, scale: 4
      t.decimal :rate_2000, precision: 8, scale: 4
      t.decimal :rate_500_fixed, precision: 8, scale: 2
      t.decimal :rate_1000_fixed, precision: 8, scale: 2
      t.decimal :rate_2000_fixed, precision: 8, scale: 2

      t.timestamps
    end
  end
end
