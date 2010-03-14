module GalleriesHelper
  
  def gallery_image_tag(dim_name, gallery)
    if gallery.gallery_image_id
      image = gallery.images.find(gallery.gallery_image_id)
     return image_tag(dim_name, image, gallery)
   else
     return nil
   end
 end
 
end
