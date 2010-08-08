class Gallery < ActiveRecord::Base
  has_many :gdjoins
  has_many :dimensions, :through => :gdjoins
  has_many :images, :dependent => :destroy
  belongs_to :holder, :polymorphic => true

  def after_save
    base_path = "#{Gallery.absolute_path}/#{self.holder}/#{self.id.to_s}"
    FileUtils.mkdir_p(base_path)
  end

  def after_destroy
    base_path = "#{Gallery.absolute_path}/#{self.holder}/#{self.id.to_s}"
    FileUtils.remove_entry_secure(base_path)
  end

  def self.dirname
    return "galleries"
  end

  def self.absolute_path
    return "#{RAILS_ROOT}/public#{relative_path}"
  end

  def self.relative_path
    return "/#{self.dirname}"
  end

  def holder
    return self.holder_type.pluralize.downcase
  end

  def gallery_image_tag(dim_name)
    if self.gallery_image_id
      image = gallery.images.find(self.gallery_image_id)
     return image.tag(dim_name)
   else
     return nil
   end
 end
end