class TransactionsAddPaypalAuth < ActiveRecord::Migration
  def change
    add_column :transactions, :paypal_auth, :string
  end
end
