class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :trans_type
      t.decimal :amount, precision: 8, scale: 2
      t.string :payment_service
      t.integer :user_id
      
      t.timestamps
    end
  end
end
