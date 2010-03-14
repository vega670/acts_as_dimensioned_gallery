module ImagesHelper
  def image_tag(dim_name, image, gallery = nil)
    return image.tag(dim_name, gallery)
  end
  
end
