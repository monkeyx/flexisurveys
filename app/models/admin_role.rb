class AdminRole < ActiveRecord::Base
  validates_presence_of :name
  
  def self.free
    find(:first, :conditions => {:name => 'free'})
  end
  def self.basic
    find(:first, :conditions => {:name => 'basic'})
  end
  def self.premium
    find(:first, :conditions => {:name => 'premium'})
  end
end