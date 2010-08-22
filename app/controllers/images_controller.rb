class ImagesController < AadgController
  
  before_filter :find_gallery
  
  def index
    @images = @gallery.images
  end

  def show
    if params[:dimension_id]
      @dimension = Dimension.find(params[:dimension_id])
      @image = @dimension.galleries.images.find(params[:id])
    else
      @image = @gallery.images.find(params[:id])
    end
  end
end
