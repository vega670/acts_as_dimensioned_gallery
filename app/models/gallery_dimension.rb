class GalleryDimension < ActiveRecord::Base
  belongs_to :gallery
  belongs_to :dimension

  def after_save
    gallery = Gallery.find(self.gallery_id)
    dimension = Dimension.find(self.dimension_id)

    gallery.images.each do |image|
      image.create_with_dimension(dimension)
    end
  end

  def after_destroy
    gallery = Gallery.find(self.gallery_id)
    dimension = Dimension.find(self.dimension_id)

    gallery.images.each do |image|
      image.destroy_with_dimension(dimension)
    end
  end
end
