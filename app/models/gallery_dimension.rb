class GalleryDimension < ActiveRecord::Base
  belongs_to :gallery
  belongs_to :dimension
  
  after_save :create_images
  after_destroy :delete_images

  def create_images
    gallery = Gallery.find(self.gallery_id)
    dimension = Dimension.find(self.dimension_id)

    gallery.images.each do |image|
      image.create_with_dimension(dimension)
    end
  end

  def delete_images
    gallery = Gallery.find(self.gallery_id)
    dimension = Dimension.find(self.dimension_id)

    gallery.images.each do |image|
      image.destroy_with_dimension(dimension)
    end
  end
end
