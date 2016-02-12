class AddAttachmentBillImageToBills < ActiveRecord::Migration
  def self.up
    change_table :bills do |t|
      t.attachment :bill_image
    end
  end

  def self.down
    drop_attached_file :bills, :bill_image
  end
end
