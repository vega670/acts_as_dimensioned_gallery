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
    @gallery = @holder_url.galleries.find(params[:id])
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



  def set_gallery_image
    gallery = @holder_url.galleries.find(params[:gallery_id])
    gallery.gallery_image_id = params[:image_id]
    gallery.save
    
    render :text => 'Image set as gallery image.'
  end
end
