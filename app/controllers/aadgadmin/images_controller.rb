class Aadgadmin::ImagesController < Aadgadmin::AadgController
  layout 'application'
  
  before_filter :find_gallery
  
  def index
    if @gallery
      @images = @gallery.images
    else
      @images = Image.all
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  def new
    if @gallery
      @image = @gallery.images.new
    else
      @image = Image.new
    end
  end
  
  def create
    @image = @gallery.images.build(params[:image])
    
    respond_to do |format|
      if @image.save
        if @gallery
          format.html { redirect_to url_for([@holder, @gallery]) }
        else
          format.html { redirect_to(@image) }
        end
      else
        format.html {render :action => "new" }
      end
    end
  end
  
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    
    respond_to do |format|
      if @gallery
        format.html { redirect_to url_for([@holder, @gallery]) }
      else
        format.html { redirect_to(@image) }
      end
    end
  end
end
