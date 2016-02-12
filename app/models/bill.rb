class Bill < ActiveRecord::Base
  
  belongs_to :user
  validates :user_id, presence: true
  
  has_attached_file :bill_image, 
                    :styles => { :regular => "800x800>", :thumb => "100x100>" }
                    # other options set in /config/initializers/paperclip.rb
#  validates_attachment_content_type :bill_image, :content_type => /\Aimage\/.*\Z/
  
end
