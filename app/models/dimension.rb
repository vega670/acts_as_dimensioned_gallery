class Dimension < ActiveRecord::Base
  has_many :gdjoins
  has_many :galleries, :through => :gdjoins
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "belongs to another dimension."
  
  validates_format_of :name, :with => /^[a-zA-Z0-9\s]*$/, :message => "must only be letters, numbers, and spaces."
  
  validates_presence_of :name
  
  def validate
    if (self.name.downcase <=> Image.unaltered_file) == 0
      errors.add_to_base "Cannot create dimension named #{Image.unaltered_file.capitalize}. That is a reserved name."
    end

    if ((self.height) ? self.height < 1 : false) || ((self.width) ? self.width < 1 : false)
      errors.add_to_base "Smallest acceptable dimension is 1x1 pixels."
    end

    if (self.aspect) ? self.aspect <= 0 : false
      errors.add_to_base "Aspect ratios must be greater than 0."
    end

    if !self.resize && !self.crop
      errors.add_to_base "Resize and/or Crop must be selected."
    end

    if !self.aspect && !self.width && !self.height
      errors.add_to_base "Dimensions must have at least one of the following: Width, Height, Aspect ratio."
    end
  end

  def before_update
    dimension = Dimension.find(self.id)
    gdjoins = Gdjoin.find(:all, :conditions => "dimension_id = #{self.id}")
    if (dimension.width != self.width) || (dimension.height != self.height) || (dimension.aspect != self.aspect) || (dimension.resize != self.resize) || (dimension.crop != self.crop)
      gdjoins.each do |gdjoin|
        gallery = Gallery.find(gdjoin.gallery_id)
        gallery.images.each do |image|
          image.destroy_with_dimension(dimension)
          image.create_with_dimension(self)
        end
      end
    else
      gdjoins.each do |gdjoin|
        gallery = Gallery.find(gdjoin.gallery_id)
        gallery.images.each do |image|
          image.rename_with_dimension(dimension, self)
        end
      end
    end
  end
end