class Aadgadmin::GalleriesController < Aadgadmin::AadgController
  
  before_filter :find_dimension

  def index
    if @dimension
      @galleries = @dimension.galleries
    else
      @galleries = @holder_url.galleries
    end
  end
  
  
  def show
    if @dimension
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
    @dimensions = @gallery.dimensions
  end
  

  def new
    if @holder_url
      @gallery = @holder_url.galleries.new
    else
      render_404
    end
  end


  def edit
    if @holder_url
      @gallery = @holder_url.galleries.find(params[:id])
    else
      render_404
    end
  end


  def create
    if @holder_url
      @gallery = @holder_url.galleries.create(params[:gallery])

      respond_to do |format|
        if @gallery.save
          format.html { redirect_to url_for([@holder_url, :aadgadmin, @gallery]) }
        else
          format.html { render :action => 'new'}
        end
      end
    else
      render_404
    end
  end


  def update
    if @holder_url
      @gallery = @holder_url.galleries.find(params[:id])

      respond_to do |format|
        if @gallery.update_attributes(params[:gallery])
          flash[:notice] = "Gallery successfully updated."
          format.html { redirect_to url_for([@holder_url, :aadgadmin, @gallery]) }
        else
          format.html { render :action => 'edit' }
        end
      end
    else
      render_404
    end
  end


  def destroy
    if @holder_url
      @gallery = @holder_url.galleries.find(params[:id])
      @gallery.destroy

      respond_to do |format|
        format.html { redirect_to url_for([@holder_url, :aadgadmin, :galleries]) }
      end
    else
      render_404
    end
  end
end
