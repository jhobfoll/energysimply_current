class AddReferralKey < ActiveRecord::Migration
  def change
    add_column :users, :referral_key, :string
    add_column :users, :referred_by_id, :integer
    add_column :visitors, :referred_by_id, :integer
  end
end
