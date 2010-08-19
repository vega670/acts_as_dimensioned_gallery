class ImagesController < AadgController
  layout 'aadg'
  
  before_filter :find_gallery
  
  def index
    @images = @gallery.images
  end

  def show
    @image = @gallery.images.find(params[:id])
  end
end
