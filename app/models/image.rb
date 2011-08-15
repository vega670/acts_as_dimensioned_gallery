class Image < ActiveRecord::Base
  require 'open-uri'
  
  # OpenURI::Buffer::StringMax = 10240
  OpenURI::Buffer::StringMax = 0
  
  belongs_to :gallery
  
  after_save :create_dimensioned
  after_destroy :delete_image
  
  validate :check_format
  

  def file= (f)
    self.original_filename = f.original_filename
    @file = f
  end

  def file
    return @file
  end

  def self.unaltered_file
    return 'original'
  end

  def check_format
    errors.add_on_empty 'name'
    
    if !(self.file.kind_of? ActionDispatch::Http::UploadedFile)
      errors.add :base, 'No file selected.'
      return
    end
    
    meta = `#{IMAGE_MAGICK_PATH}/identify -format %m,%w,%h #{self.file.path} 2>&1`
    meta_strs = meta.split(',')
    
    self.width = meta_strs[1].to_i
    self.height = meta_strs[2].to_i
    
    if !meta_strs || !(meta_strs[0] == 'JPEG' || meta_strs[0] == 'PNG') || self.height <= 0 || self.width <= 0
      errors.add :base, 'Data contains errors or is not a supported format.'
    end
  end
  
  def create_dimensioned
    gallery = Gallery.find(self.gallery_id)
    temp_path = self.file.path
    base_path = "#{Gallery.absolute_path}/#{gallery.holder}/#{gallery.id.to_s}/#{self.id.to_s}"
    FileUtils.mkdir_p(base_path)
    
    # keep original copy
    original_path = "#{base_path}/#{Image.unaltered_file}.jpg"
    FileUtils.cp(temp_path, original_path)
    
    dims = gallery.dimensions
    
    dims.each do |dim|
      self.create_with_dimension(dim)
    end
  end
  
  def delete_image
    base_path = "#{Gallery.absolute_path}/#{gallery.holder}/#{gallery.id.to_s}/#{self.id.to_s}"
    FileUtils.remove_entry_secure(base_path)
  end
  
  def create_with_dimension(dimension)
    gallery = Gallery.find(self.gallery_id)
    
    base_path = "#{Gallery.absolute_path}/#{gallery.holder}/#{gallery.id.to_s}/#{self.id.to_s}"
    dim_name = dimension.name.gsub(/[\s]/,"_").gsub(/[\W]/,"").downcase
    dest_path = "#{base_path}/#{dim_name}.jpg"
    
    src_path = "#{base_path}/#{Image.unaltered_file}.jpg"
    
    FileUtils.cp(src_path, dest_path)
    
    base_command = "#{IMAGE_MAGICK_PATH}/convert \"#{dest_path}\""
    
    if dimension.crop?
      if dimension.resize?
        if dimension.aspect
          aspect_ratio = dimension.aspect
        elsif dimension.height && dimension.width
          aspect_ratio = (dimension.width.to_f / dimension.height.to_f)
        end
        
        crop_width = (self.height * aspect_ratio).round
        crop_height = (self.width * (1/aspect_ratio)).round
      else
        if dimension.aspect
          crop_width = (self.height * dimension.aspect).round
          crop_height = (self.width * (1/dimension.aspect)).round
        else
          if dimension.width && !dimension.height
            crop_width = dimension.width
            crop_height = self.height
          elsif !dimension.width && dimension.height
            crop_width = self.width
            crop_height = dimension.height
          elsif dimension.width && dimension.height
            crop_width = dimension.width
            crop_height = dimension.height
          end
        end
      end
      
      y_offset = 0
      x_offset = 0
      
      if self.height > crop_height
        y_offset = ((self.height - crop_height)/2).round
      elsif self.width > crop_width
        x_offset = ((self.width - crop_width)/2).round
      end
      
      `#{base_command} -crop #{crop_width}x#{crop_height}+#{x_offset}+#{y_offset} "#{dest_path}"`
    end
    
    if dimension.resize?
      if dimension.width && !dimension.height
        `#{base_command} -resize #{dimension.width} -quality 100 "#{dest_path}"`
      elsif !dimension.width && dimension.height
        `#{base_command} -resize x#{dimension.height} -quality 100 "#{dest_path}"`
      elsif dimension.width && dimension.height
        `#{base_command} -resize #{dimension.width}x#{dimension.height}> -quality 100 "#{dest_path}"`
      end
    end
  end
  
  def destroy_with_dimension(dimension)
    gallery = Gallery.find(self.gallery_id)
    
    base_path = "#{Gallery.absolute_path}/#{gallery.holder}/#{gallery.id.to_s}/#{self.id.to_s}"
    dim_name = dimension.name.gsub(/[\s]/,"_").gsub(/[\W]/,"").downcase
    dest_path = "#{base_path}/#{dim_name}.jpg"
    
    FileUtils.rm(dest_path)
  end

  def rename_with_dimension(old, new)
    gallery = Gallery.find(self.gallery_id)

    base_path = "#{Gallery.absolute_path}/#{gallery.holder}/#{gallery.id.to_s}/#{self.id.to_s}"
    old_name = old.name.gsub(/[\s]/,"_").gsub(/[\W]/,"").downcase
    new_name = new.name.gsub(/[\s]/,"_").gsub(/[\W]/,"").downcase
    old_path = "#{base_path}/#{old_name}.jpg"
    new_path = "#{base_path}/#{new_name}.jpg"

    FileUtils.mv(old_path, new_path)
  end
  
  def tag(dim_name = Image.unaltered_file, options = {})
    gallery = Gallery.find(self.gallery_id)
    
    image_path = self.src(dim_name, gallery)
    return "<img src=\"#{image_path}\" alt=\"#{self.name}\" />"
  end
  
  def src(dim_name = Image.unaltered_file, gallery = nil)
    if !gallery
      gallery = Gallery.find(self.gallery_id)
    end

    if (dim_name.downcase <=> Image.unaltered_file) == 0
      image_name = Image.unaltered_file
    else
      image_name = dim_name.gsub(/[\s]/,"_").gsub(/[\W]/,"").downcase
    end
    return "#{Gallery.relative_path}/#{gallery.holder}/#{gallery.id.to_s}/#{self.id.to_s}/#{image_name}.jpg"
  end


  def holder(gallery = nil)
    if !gallery
      gallery = Gallery.find(self.gallery_id)
    end

    return gallery.holder_type.pluralize.downcase
  end
end
