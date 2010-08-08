class Dimension < ActiveRecord::Base
  has_many :gdjoins
  has_many :galleries, :through => :gdjoins
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "belongs to another dimension"
  
  validates_format_of :name, :with => /^([a-zA-Z0-9])/, :message => "must only be letters, numbers, and spaces"
  
  validates_presence_of :name
  
  def validate
    if ((self.height) ? self.height < 1 : false) || ((self.width) ? self.width < 1 : false)
      errors.add_to_base "Smallest acceptable dimension is 1x1 pixels."
    end

    if (self.aspect) ? self.aspect <= 0 : false
      errors.add_to_base "Aspect ratios must be greater than 0."
    end

  end

  def before_update
    gdjoins = Gdjoin.find(:all, :conditions => "dimension_id = #{self.id}")
    dimension = Dimension.find(self.id)
    gdjoins.each do |gdjoin|
      gallery = Gallery.find(gdjoin.gallery_id)
      gallery.images.each do |image|
        image.destroy_with_dimension(dimension)
        image.create_with_dimension(self)
      end
    end
  end
end