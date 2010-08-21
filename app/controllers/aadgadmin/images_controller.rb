class Aadgadmin::ImagesController < Aadgadmin::AadgController
  
  before_filter :find_gallery
  
  def index
    @images = @gallery.images
  end

  def show
    @image = @gallery.images.find(params[:id])
  end

  def new
    @image = @gallery.images.new
  end
  
  def create
    @image = @gallery.images.build(params[:image])
    
    respond_to do |format|
      if @image.save
        format.html { redirect_to url_for([@holder_url, :aadgadmin, @gallery]) }
      else
        format.html {render :action => "new" }
      end
    end
  end
  
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    
    respond_to do |format|
      format.html { redirect_to url_for([@holder_url, :aadgadmin, @gallery]) }
    end
  end

  def set_gallery_image
    gallery = Gallery.find(params[:gallery_id])
    gallery.gallery_image_id = params[:id]

    if gallery.save
      render :text => 'Image set as gallery image.'
    else
      render :text => 'An error occured while setting gallery image.'
    end
  end
end
