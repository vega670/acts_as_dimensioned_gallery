class ImagesController < AadgController
  
  before_filter :find_gallery
  
  def index
    @images = @gallery.images
  end

  def show
    @image = @gallery.images.find(params[:id])
  end
end
