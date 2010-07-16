class Dimension < ActiveRecord::Base
  has_many :gdjoins
  has_many :galleries, :through => :gdjoins
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "belongs to another dimension"
  
  validates_format_of :name, :with => /^([a-zA-Z0-9])/, :message => "must only be letters, numbers, and spaces"
  
  validates_presence_of :name

  
end