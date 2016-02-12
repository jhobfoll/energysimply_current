class UsersPaymentCols < ActiveRecord::Migration
  def change
      add_column :users, :dwolla_id, :integer
      add_column :users, :paypal_id, :integer
      add_column :users, :active_payment_service, :string
  end
end
