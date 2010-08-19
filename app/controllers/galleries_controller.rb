class GalleriesController < AadgController
  
  def index
    @galleries = @holder.galleries
  end


  def show
    @gallery = @holder.galleries.find(params[:id])
  end
end
