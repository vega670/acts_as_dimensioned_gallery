class Gallery < ActiveRecord::Base
  has_many :gdjoins
  has_many :dimensions, :through => :gdjoins
  has_many :images, :dependent => :destroy
  belongs_to :holder, :polymorphic => true
  
  def self.path
    return "galleries"
  end

  def gallery_image_tag(dim_name)
    if self.gallery_image_id
      image = gallery.images.find(self.gallery_image_id)
     return image.tag(dim_name)
   else
     return nil
   end
 end
  
  def create_dimension(dimension)
    self.images.each do |image|
      image.create_with_dimension(dimension)
    end
  end
  
  def destroy_dimension(dimension)
    self.images.each do |image|
      image.destroy_with_dimension(dimension)
    end
  end
end