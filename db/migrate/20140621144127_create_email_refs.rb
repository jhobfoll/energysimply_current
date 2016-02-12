class CreateEmailRefs < ActiveRecord::Migration
  def change
    create_table :email_refs do |t|
      t.string :email
      t.datetime :ref_date
      t.integer :refd_by

      t.timestamps
    end
  end
end
