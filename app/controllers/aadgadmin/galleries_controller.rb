class Aadgadmin::GalleriesController < Aadgadmin::AadgController

  layout 'aadg_admin'
  
  def index
    if params[:dimension_id]
      @dimension = Dimension.find(params[:dimension_id])
      @galleries = @dimension.galleries
    else
      @galleries = @holder.galleries
    end
  end
  
  
  def show
    @gallery = @holder.galleries.find(params[:id])
  end
  

  def new
    @gallery = @holder.galleries.new
  end


  def edit
    @gallery = @holder.galleries.find(params[:id])
  end


  def create
    @gallery = @holder.galleries.create(params[:gallery])

    respond_to do |format|
      if @gallery.save
        format.html { redirect_to url_for([@holder, :aadgadmin, @gallery]) }
      else
        format.html { render :action => 'new'}
      end
    end
  end


  def update
    @gallery = @holder.galleries.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = "Gallery successfully updated."
        format.html { redirect_to url_for([@holder, :aadgadmin, @gallery]) }
      else
        format.html { render :action => 'edit' }
      end
    end
  end


  def destroy
    @gallery = @holder.galleries.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to url_for([@holder, :aadgadmin, :galleries]) }
    end
  end



  def set_gallery_image
    gallery = @holder.galleries.find(params[:gallery_id])
    gallery.gallery_image_id = params[:image_id]
    gallery.save
    
    render :text => 'Image set as gallery image.'
  end
end
