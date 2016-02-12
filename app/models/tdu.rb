class Tdu < ActiveRecord::Base
  #attr_accessible :name, :apt_avg, :apt_best, :house_avg, :house_best
  
  has_many :zips
  
end
