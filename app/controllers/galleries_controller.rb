class GalleriesController < AadgController
  
  def index
    @galleries = @holder_url.galleries
  end


  def show
    @gallery = @holder_url.galleries.find(params[:id])
  end
end
