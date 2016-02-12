class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :svc_address_1
      t.string :svc_address_2
      t.string :current_provider
      t.string :kwh_usage
      t.string :energy_charge
      t.string :usage_charge
      t.string :esi_id
      t.string :meter_number
      t.string :account_number
      t.string :plan_end_date
      t.decimal :last_bill_amount, precision: 8, scale: 2
      t.integer :user_id

      t.timestamps
    end
  end
end
