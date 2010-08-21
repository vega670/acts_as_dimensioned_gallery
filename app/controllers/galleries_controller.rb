class GalleriesController < AadgController
  
  def index
    @galleries = @holder_url.galleries
  end


  def show
    @gallery = @holder_url.galleries.find(params[:id])
    if @gallery.gallery_dimension_id
      @gallery_dimension = Dimension.find(@gallery.gallery_dimension_id)
    end
    if @gallery.gallery_image_id
      @gallery_image = Image.find(@gallery.gallery_image_id)
    end
  end
end
