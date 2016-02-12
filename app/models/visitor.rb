class Visitor < ActiveRecord::Base

  belongs_to :zip #zip_id is the default remote-key
  has_one :user
  belongs_to :customer_usage

end
