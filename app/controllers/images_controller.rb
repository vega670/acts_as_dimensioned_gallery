class ImagesController < AadgController
  layout 'application'
  
  before_filter :find_gallery
  
  def index
    @images = @gallery.images
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @image = Image.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def new
    @image = @gallery.images.new
    
    respond_to do |format|
      format.html
    end
  end

  def edit
    @image = Image.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @image = @gallery.images.build(params[:image])
    
    respond_to do |format|
      if @image.save
        format.html { redirect_to(@gallery) }
      else
        format.html {render :action => "new" }
      end
    end
  end
  
  def update
    
  end
  
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    
    respond_to do |format|
      format.html { redirect_to(@gallery) }
    end
  end
  
  private
    def find_gallery
      @gallery = Gallery.find(params[:gallery_id])
    end
end
