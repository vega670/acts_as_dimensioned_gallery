class Aadgadmin::GalleriesController < Aadgadmin::AadgController
  
  def index
    if params[:dimension_id]
      @dimension = Dimension.find(params[:dimension_id])
      @galleries = @dimension.galleries
    else
      @galleries = @holder_url.galleries
    end
  end
  
  
  def show
    if params[:dimension_id]
      @dimension = Dimension.find(params[:dimension_id])
      @gallery = @dimension.galleries.find(params[:id])
    else
      @gallery = @holder_url.galleries.find(params[:id])
    end
    if @gallery.gallery_dimension_id
      @gallery_dimension = Dimension.find(@gallery.gallery_dimension_id)
    end
    if @gallery.gallery_image_id
      @gallery_image = Image.find(@gallery.gallery_image_id)
    end
  end
  

  def new
    @gallery = @holder_url.galleries.new
  end


  def edit
    @gallery = @holder_url.galleries.find(params[:id])
  end


  def create
    @gallery = @holder_url.galleries.create(params[:gallery])

    respond_to do |format|
      if @gallery.save
        format.html { redirect_to url_for([@holder_url, :aadgadmin, @gallery]) }
      else
        format.html { render :action => 'new'}
      end
    end
  end


  def update
    @gallery = @holder_url.galleries.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = "Gallery successfully updated."
        format.html { redirect_to url_for([@holder_url, :aadgadmin, @gallery]) }
      else
        format.html { render :action => 'edit' }
      end
    end
  end


  def destroy
    @gallery = @holder_url.galleries.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to url_for([@holder_url, :aadgadmin, :galleries]) }
    end
  end
end
