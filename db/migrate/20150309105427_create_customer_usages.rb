class CreateCustomerUsages < ActiveRecord::Migration
  def change
    create_table :customer_usages do |t|
      t.decimal :mo_01,        precision: 8, scale: 2
      t.decimal :mo_02,        precision: 8, scale: 2
      t.decimal :mo_03,        precision: 8, scale: 2
      t.decimal :mo_04,        precision: 8, scale: 2
      t.decimal :mo_05,        precision: 8, scale: 2
      t.decimal :mo_06,        precision: 8, scale: 2
      t.decimal :mo_07,        precision: 8, scale: 2
      t.decimal :mo_08,        precision: 8, scale: 2
      t.decimal :mo_09,        precision: 8, scale: 2
      t.decimal :mo_10,        precision: 8, scale: 2
      t.decimal :mo_11,        precision: 8, scale: 2
      t.decimal :mo_12,        precision: 8, scale: 2

      t.timestamps
    end

    add_column :visitors, :customer_usage_id, :integer
    add_column :users, :customer_usage_id, :integer
  end

end
