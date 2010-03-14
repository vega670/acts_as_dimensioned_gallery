class Gallery < ActiveRecord::Base
  has_many :gdjoins
  has_many :dimensions, :through => :gdjoins
  has_many :images, :dependent => :destroy
  belongs_to :holder, :polymorphic => true
  
  def self.path
    return "galleries"
  end
  
  def create_dimension(dimension)
    self.images.each do |image|
      image.create_with_dimension(dimension, self)
    end
  end
  
  def destroy_dimension(dimension)
    self.images.each do |image|
      image.destroy_with_dimension(dimension, self)
    end
  end
end