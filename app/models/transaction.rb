	class Transaction < ActiveRecord::Base
  
  belongs_to :user
  
  validates :user_id, presence: true
  #TODO More Validations on column-values
  
end
