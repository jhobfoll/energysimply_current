class TransactionsAddStripeMorecols < ActiveRecord::Migration
  def change
    add_column :transactions, :last4, :string
    add_column :transactions, :brand, :string
    add_column :transactions, :funding, :string
    add_column :transactions, :exp_month, :string
    add_column :transactions, :exp_year, :string
    add_column :transactions, :stripe_callback_data, :text
    change_column :transactions, :stripe_id, :string
  end
end
