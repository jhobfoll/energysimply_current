class CreateClickTrackings < ActiveRecord::Migration
  def change
    create_table :click_trackings do |t|
      t.string :zip
      t.string :url
      t.integer :user_id

      t.timestamps
    end
  end
end
