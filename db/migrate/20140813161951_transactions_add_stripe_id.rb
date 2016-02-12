class TransactionsAddStripeId < ActiveRecord::Migration
  def change
    add_column :transactions, :stripe_id, :integer
  end
end
